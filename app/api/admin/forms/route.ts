import { NextRequest, NextResponse } from "next/server"
import { createServiceClient } from "@/lib/supabase-service"
import { requireAdmin, pickAllowed } from "@/lib/api-auth"

// Columnas editables vía PATCH (evita mass assignment).
const FORM_EDITABLE = [
  "slug", "title", "description", "fields",
  "default_priority", "default_tags", "default_assignees", "is_active",
] as const

// GET — list all forms with submission counts (admin only)
export async function GET(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail

  const db = createServiceClient()
  const { data, error } = await db
    .from("task_forms")
    .select("*")
    .order("created_at", { ascending: false })
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ forms: data ?? [] })
}

// POST — create a new form (admin only)
export async function POST(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail
  const { user } = auth.caller

  let body: any
  try { body = await req.json() } catch { return NextResponse.json({ error: "JSON inválido" }, { status: 400 }) }

  if (!body.slug || !body.title) {
    return NextResponse.json({ error: "Faltan slug y title" }, { status: 400 })
  }
  // Slug validation: lowercase letters, numbers, hyphens
  if (!/^[a-z0-9-]+$/.test(body.slug)) {
    return NextResponse.json({ error: "Slug solo puede tener letras minúsculas, números y guiones" }, { status: 400 })
  }

  const db = createServiceClient()

  // Check uniqueness
  const { data: existing } = await db.from("task_forms").select("id").eq("slug", body.slug).maybeSingle()
  if (existing) {
    return NextResponse.json({ error: `Ya existe un form con slug "${body.slug}"` }, { status: 409 })
  }

  const { data, error } = await db
    .from("task_forms")
    .insert({
      slug:               body.slug,
      title:              body.title,
      description:        body.description ?? null,
      fields:             body.fields ?? [],
      default_priority:   body.default_priority   ?? "media",
      default_tags:       body.default_tags       ?? [],
      default_assignees:  body.default_assignees  ?? [],
      is_active:          body.is_active ?? true,
      created_by:         user.email ?? null,
    })
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ form: data })
}

// PATCH — update an existing form (admin only)
export async function PATCH(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail

  const body = await req.json()
  const { id } = body
  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })
  const updates = pickAllowed(body, FORM_EDITABLE)

  // Slug validation if changed
  if (typeof updates.slug === "string" && !/^[a-z0-9-]+$/.test(updates.slug)) {
    return NextResponse.json({ error: "Slug solo puede tener letras minúsculas, números y guiones" }, { status: 400 })
  }

  const db = createServiceClient()
  const { data, error } = await db
    .from("task_forms")
    .update(updates)
    .eq("id", id)
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ form: data })
}

// DELETE — remove a form (cascades to submissions) (admin only)
export async function DELETE(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail
  const { user } = auth.caller

  const { id } = await req.json()
  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })

  const db = createServiceClient()
  const { data: before } = await db.from("task_forms").select("slug,title,submit_count").eq("id", id).maybeSingle()

  const { error } = await db.from("task_forms").delete().eq("id", id)
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  const { audit } = await import("@/lib/audit")
  await audit(req, {
    actor:     user.email ?? null,
    action:    "form.delete",
    entity:    "task_form",
    entity_id: id,
    payload:   { before },
  })

  return NextResponse.json({ ok: true })
}
