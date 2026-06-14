import { NextRequest, NextResponse } from "next/server"
import { cookies } from "next/headers"
import {
  BRANDS, DEFAULT_BRAND_ID, ACTIVE_BRAND_COOKIE, isValidBrandId,
} from "@/lib/marketing/brands"
import { getUserIdOrNull } from "@/lib/marketing/auth-user"

const ONE_YEAR = 60 * 60 * 24 * 365

// GET /api/marketing/brand — marca activa + lista de marcas disponibles
export async function GET() {
  const userId = await getUserIdOrNull()
  if (!userId) return NextResponse.json({ error: "UNAUTHORIZED" }, { status: 401 })

  const store = await cookies()
  const sel = store.get(ACTIVE_BRAND_COOKIE)?.value
  const active = isValidBrandId(sel) ? sel : DEFAULT_BRAND_ID
  return NextResponse.json({ active, brands: BRANDS })
}

// POST /api/marketing/brand { brandId } — cambia la marca activa (cookie)
export async function POST(req: NextRequest) {
  const userId = await getUserIdOrNull()
  if (!userId) return NextResponse.json({ error: "UNAUTHORIZED" }, { status: 401 })

  const body = await req.json().catch(() => ({}))
  const id = body?.brandId
  if (!isValidBrandId(id)) {
    return NextResponse.json({ error: "INVALID_BRAND" }, { status: 400 })
  }

  const res = NextResponse.json({ active: id })
  res.cookies.set(ACTIVE_BRAND_COOKIE, id, {
    httpOnly: true,
    sameSite: "lax",
    path: "/",
    maxAge: ONE_YEAR,
  })
  return res
}
