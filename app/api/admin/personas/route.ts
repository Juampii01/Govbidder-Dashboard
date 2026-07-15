import { NextRequest, NextResponse } from "next/server"
import { createServiceClient } from "@/lib/supabase-service"
import { isAdminOrAbove } from "@/lib/types/role"
import { requireUser, requireAdmin, pickAllowed } from "@/lib/api-auth"

// Columnas editables vía PATCH (evita mass assignment).
const PERSONA_EDITABLE = [
  "name", "email", "phone", "instagram", "scheduled_at",
  "call_status", "sales_status", "owner", "source", "rating", "notes",
] as const

export async function GET(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail
  const caller = auth.caller

  const db = createServiceClient()

  // Scoping para empleados: ven sólo las personas que tienen asignadas (owner = email).
  // Admins y super_admin ven todo.
  let query = db
    .from("personas_agendadas")
    .select("*")
    .order("scheduled_at", { ascending: false, nullsFirst: false })
    .order("created_at", { ascending: false })

  if (!isAdminOrAbove(caller.role)) {
    query = query.eq("owner", caller.user.email ?? "")
  }

  const { data, error } = await query

  if (error) {
    console.error("[admin/personas GET]", error)
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  return NextResponse.json({ personas: data ?? [] })
}

export async function POST(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail

  const body = await req.json()
  if (!body?.name?.trim()) {
    return NextResponse.json({ error: "name es requerido" }, { status: 400 })
  }

  const db = createServiceClient()
  const { data, error } = await db
    .from("personas_agendadas")
    .insert({
      name:         body.name.trim(),
      email:        body.email?.trim() || null,
      phone:        body.phone?.trim() || null,
      instagram:    body.instagram?.trim() || null,
      scheduled_at: body.scheduled_at || null,
      call_status:  body.call_status  || "agendada",
      sales_status: body.sales_status || "pendiente",
      owner:        body.owner?.trim()  || null,
      source:       body.source?.trim() || null,
      rating:       body.rating ?? null,
      notes:        body.notes?.trim()  || null,
    })
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ persona: data })
}

export async function PATCH(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail
  const caller = auth.caller

  const body = await req.json()
  const { id } = body
  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })
  const updates = pickAllowed(body, PERSONA_EDITABLE)

  const db = createServiceClient()

  // Empleados solo pueden editar personas que tienen asignadas (mismo scope del GET).
  if (!isAdminOrAbove(caller.role)) {
    const { data: prev } = await db
      .from("personas_agendadas").select("owner").eq("id", id).single()
    if (!prev) return NextResponse.json({ error: "Persona no encontrada" }, { status: 404 })
    if (prev.owner !== (caller.user.email ?? "")) {
      return NextResponse.json({ error: "No podés editar esta persona" }, { status: 403 })
    }
  }

  const { data, error } = await db
    .from("personas_agendadas")
    .update(updates)
    .eq("id", id)
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ persona: data })
}

export async function DELETE(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail

  const { id } = await req.json()
  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })

  const db = createServiceClient()
  const { error } = await db.from("personas_agendadas").delete().eq("id", id)
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ success: true })
}
