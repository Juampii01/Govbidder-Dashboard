import { NextRequest, NextResponse } from "next/server"
import { createServiceClient } from "@/lib/supabase-service"
import { requireAdmin, pickAllowed } from "@/lib/api-auth"

// Columnas editables vía PATCH (evita mass assignment).
const TEMPLATE_EDITABLE = [
  "name", "description", "icon", "color",
  "parent_title", "parent_description", "parent_priority", "parent_tags",
  "parent_assignees", "parent_due_offset_days", "subtasks", "is_default",
] as const

// PATCH — update a template (admin only)
export async function PATCH(req: NextRequest, ctx: { params: Promise<{ id: string }> }) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail

  const { id } = await ctx.params
  const body = await req.json()
  const updates = pickAllowed(body, TEMPLATE_EDITABLE)

  const db = createServiceClient()
  const { data, error } = await db
    .from("task_templates")
    .update(updates)
    .eq("id", id)
    .select()
    .single()
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ template: data })
}

// DELETE — remove template (admin only)
export async function DELETE(req: NextRequest, ctx: { params: Promise<{ id: string }> }) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail
  const { id } = await ctx.params

  const db = createServiceClient()
  const { error } = await db.from("task_templates").delete().eq("id", id)
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ ok: true })
}
