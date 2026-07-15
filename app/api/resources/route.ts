import { NextRequest, NextResponse } from "next/server"
import { createServiceClient } from "@/lib/supabase-service"
import { requireUser, requireAdmin, pickAllowed } from "@/lib/api-auth"

export async function GET(req: NextRequest) {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth.fail

  const db = createServiceClient()
  const { data, error } = await db
    .from("resources")
    .select("*")
    .order("category")
    .order("created_at", { ascending: false })

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ resources: data ?? [] })
}

export async function POST(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail

  const body = await req.json()
  const { title, url, description, content, category, type } = body

  if (!title?.trim()) {
    return NextResponse.json({ error: "Título es requerido" }, { status: 400 })
  }
  // Los links necesitan URL; los docs/SOPs viven en `content` y pueden no tenerla.
  if ((type ?? "link") === "link" && !url?.trim()) {
    return NextResponse.json({ error: "URL es requerida para recursos tipo link" }, { status: 400 })
  }

  const db = createServiceClient()
  const { data, error } = await db
    .from("resources")
    .insert({
      title:       title.trim(),
      url:         url?.trim() || null,
      description: description?.trim() || null,
      content:     typeof content === "string" && content.trim() ? content : null,
      category:    category?.trim() || "General",
      type:        type || "link",
    })
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ resource: data })
}

// PATCH — editar un recurso (el Centro Operativo edita el content de los SOPs)
export async function PATCH(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail

  const body = await req.json()
  const { id } = body
  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })
  const updates = pickAllowed(body, ["title", "url", "description", "content", "category", "type"])

  const db = createServiceClient()
  const { data, error } = await db
    .from("resources")
    .update(updates)
    .eq("id", id)
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ resource: data })
}

export async function DELETE(req: NextRequest) {
  const auth = await requireAdmin(req)
  if ("fail" in auth) return auth.fail

  // Supports both ?id=... and body { id }
  const { searchParams } = new URL(req.url)
  const idFromQuery = searchParams.get("id")
  let id = idFromQuery

  if (!id) {
    try { const body = await req.json(); id = body.id } catch {}
  }

  if (!id) return NextResponse.json({ error: "id requerido" }, { status: 400 })

  const db = createServiceClient()
  const { error } = await db.from("resources").delete().eq("id", id)
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ success: true })
}
