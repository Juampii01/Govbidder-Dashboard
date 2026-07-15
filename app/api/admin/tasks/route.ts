import { NextRequest, NextResponse } from "next/server"
import { createServiceClient } from "@/lib/supabase-service"
import { isAdminOrAbove } from "@/lib/types/role"
import { requireUser, pickAllowed, type Caller } from "@/lib/api-auth"

// Columnas editables vía PATCH (evita mass assignment de created_by, etc.).
const TASK_EDITABLE = [
  "title", "description", "status", "priority", "owner", "assignees", "tags",
  "due_at", "persona_id", "parent_id", "department_id", "sort_order",
  "is_recurrence_template", "recurrence_rule", "recurrence_until",
] as const

/** ¿El caller puede tocar esta task? (admins siempre; el resto si es suya o de su depto) */
function canTouchTask(
  caller: Caller,
  task: { owner: string | null; assignees: string[] | null; department_id: string | null; created_by: string | null },
): boolean {
  if (isAdminOrAbove(caller.role)) return true
  const email = caller.user.email ?? ""
  if (!email) return false
  return (
    task.owner === email ||
    (task.assignees ?? []).includes(email) ||
    task.created_by === email ||
    (caller.departmentId !== null && task.department_id === caller.departmentId)
  )
}

// GET /api/admin/tasks
//   ?persona_id=xxx     filter by persona
//   ?owner=foo          filter where owner = foo
//   ?assignee=foo       filter where foo is in assignees array
//   ?status=pendiente   filter by status
//   ?parent_id=xxx      get subtasks of a parent
//   ?include_subtasks=true  default behavior returns top-level only; set true to also return all
export async function GET(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail
  const caller = auth.caller

  const personaId       = req.nextUrl.searchParams.get("persona_id")
  const owner           = req.nextUrl.searchParams.get("owner")
  const assignee        = req.nextUrl.searchParams.get("assignee")
  const status          = req.nextUrl.searchParams.get("status")
  const parentId        = req.nextUrl.searchParams.get("parent_id")
  const includeSubtasks = req.nextUrl.searchParams.get("include_subtasks") === "true"

  const db = createServiceClient()
  let query = db.from("tasks").select("*")

  // Scoping para empleados: ven solo tasks de su depto + las que tienen asignadas
  // por owner/assignees. Admins y super_admin ven todo.
  if (!isAdminOrAbove(caller.role)) {
    const email = caller.user.email ?? ""
    if (caller.departmentId) {
      query = query.or(
        `department_id.eq.${caller.departmentId},owner.eq.${email},assignees.cs.{${email}}`
      )
    } else {
      // Empleado sin depto asignado: solo ve tasks suyas (owner o assignee).
      query = query.or(`owner.eq.${email},assignees.cs.{${email}}`)
    }
  }

  if (personaId)              query = query.eq("persona_id", personaId)
  if (owner)                  query = query.eq("owner", owner)
  if (assignee)               query = query.contains("assignees", [assignee])
  if (status)                 query = query.eq("status", status)
  if (parentId)               query = query.eq("parent_id", parentId)
  else if (!includeSubtasks)  query = query.is("parent_id", null)

  const { data, error } = await query
    .order("due_at", { ascending: true, nullsFirst: false })
    .order("created_at", { ascending: false })

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ tasks: data ?? [] })
}

export async function POST(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail
  const { user } = auth.caller

  const body = await req.json()
  if (!body?.title?.trim()) {
    return NextResponse.json({ error: "title es requerido" }, { status: 400 })
  }

  const db = createServiceClient()
  const { data, error } = await db
    .from("tasks")
    .insert({
      title:       body.title.trim(),
      description: body.description?.trim() || null,
      status:      body.status   || "pendiente",
      priority:    body.priority || "media",
      owner:       body.owner?.trim() || null,
      assignees:   Array.isArray(body.assignees) ? body.assignees.filter(Boolean) : [],
      tags:        Array.isArray(body.tags)      ? body.tags.filter(Boolean)      : [],
      due_at:      body.due_at   || null,
      persona_id:  body.persona_id || null,
      parent_id:     body.parent_id    || null,
      department_id: body.department_id || null,
      created_by:    user.email || user.id,
    })
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  // Auto-log creation as a system comment
  await db.from("task_comments").insert({
    task_id: data.id,
    author:  user.email || user.id,
    kind:    "system",
    content: "Tarea creada",
  })

  return NextResponse.json({ task: data })
}

export async function PATCH(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail
  const caller = auth.caller

  const body = await req.json()
  const { id } = body
  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })
  const updates = pickAllowed(body, TASK_EDITABLE)

  const db = createServiceClient()

  // Snapshot: sirve para el activity log Y para el check de ownership.
  const { data: prev } = await db
    .from("tasks")
    .select("status, priority, assignees, owner, department_id, created_by")
    .eq("id", id)
    .single()
  if (!prev) return NextResponse.json({ error: "Task no encontrada" }, { status: 404 })

  if (!canTouchTask(caller, prev)) {
    return NextResponse.json({ error: "No podés editar esta tarea" }, { status: 403 })
  }

  // Auto-stamp completed_at on status flip
  if (updates.status === "completada") {
    updates.completed_at = new Date().toISOString()
  } else if (updates.status && updates.status !== "completada") {
    updates.completed_at = null
  }

  const { data, error } = await db
    .from("tasks")
    .update(updates)
    .eq("id", id)
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  // Log meaningful changes
  const author = caller.user.email || caller.user.id
  const events: string[] = []
  if (updates.status && prev.status !== updates.status) {
    events.push(`Estado: ${prev.status} → ${updates.status}`)
  }
  if (updates.priority && prev.priority !== updates.priority) {
    events.push(`Prioridad: ${prev.priority} → ${updates.priority}`)
  }
  for (const txt of events) {
    await db.from("task_comments").insert({ task_id: id, author, kind: "system", content: txt })
  }

  return NextResponse.json({ task: data })
}

export async function DELETE(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail
  const caller = auth.caller

  const { id } = await req.json()
  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })

  const db = createServiceClient()

  // Snapshot for audit + ownership check
  const { data: before } = await db
    .from("tasks")
    .select("title,status,priority,owner,created_by")
    .eq("id", id)
    .maybeSingle()
  if (!before) return NextResponse.json({ error: "Task no encontrada" }, { status: 404 })

  // Borrar es más destructivo que editar: solo admins, el creador o el owner.
  const email = caller.user.email ?? ""
  const canDelete =
    isAdminOrAbove(caller.role) ||
    (email !== "" && (before.created_by === email || before.owner === email))
  if (!canDelete) {
    return NextResponse.json({ error: "No podés borrar esta tarea" }, { status: 403 })
  }

  const { error } = await db.from("tasks").delete().eq("id", id)
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  // Audit (fire and forget)
  const { audit } = await import("@/lib/audit")
  await audit(req, {
    actor:     caller.user.email ?? null,
    action:    "task.delete",
    entity:    "task",
    entity_id: id,
    payload:   { before },
  })

  return NextResponse.json({ success: true })
}
