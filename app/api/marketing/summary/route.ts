import { NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase"
import { createServiceClient } from "@/lib/supabase-service"

async function getUser(req: NextRequest) {
  const token = req.headers.get("authorization")?.replace("Bearer ", "")
  if (!token) return null
  const { data: { user } } = await createClient().auth.getUser(token)
  return user
}

export async function GET(req: NextRequest) {
  const user = await getUser(req)
  if (!user) return NextResponse.json({ error: "No autorizado" }, { status: 401 })

  const db = createServiceClient()

  // Resolve clientId desde la tabla Profile del Content Dashboard (mismo Supabase)
  const { data: cdProfile } = await db
    .from("Profile")
    .select("clientId")
    .eq("id", user.id)
    .maybeSingle()

  const clientId = cdProfile?.clientId
  if (!clientId) {
    return NextResponse.json({ connected: false, social: [], pipeline: {}, ads: null })
  }

  const [snapshotsRes, pipelineRes, campaignsRes] = await Promise.all([
    // Último snapshot por plataforma (IG, YT, TikTok)
    db
      .from("AccountSnapshot")
      .select("platform, followers, totalViews, reach, engagementRate, newFollowers, date")
      .eq("clientId", clientId)
      .order("date", { ascending: false })
      .limit(30),

    // Pipeline de contenido — conteos por status
    db
      .from("ContentPiece")
      .select("status, date")
      .eq("clientId", clientId),

    // Campañas de ads
    db
      .from("AdCampaign")
      .select("spend, roas, impressions, clicks, conversions, status")
      .eq("clientId", clientId),
  ])

  // Último snapshot por plataforma
  const platformLatest: Record<string, any> = {}
  for (const snap of snapshotsRes.data ?? []) {
    if (!platformLatest[snap.platform]) platformLatest[snap.platform] = snap
  }

  // Pipeline: conteos + piezas que se publican en los próximos 7 días
  const pipelineCounts: Record<string, number> = {}
  const now = new Date()
  const nextWeek = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000)
  let scheduledSoon = 0
  for (const piece of pipelineRes.data ?? []) {
    pipelineCounts[piece.status] = (pipelineCounts[piece.status] ?? 0) + 1
    if (piece.status === "programado" && piece.date) {
      const d = new Date(piece.date)
      if (d >= now && d <= nextWeek) scheduledSoon++
    }
  }

  // Ads: totales
  let ads = null
  const allCampaigns = campaignsRes.data ?? []
  if (allCampaigns.length > 0) {
    const active = allCampaigns.filter(c => c.status === "ACTIVE")
    const totalSpend = allCampaigns.reduce((s, c) => s + (c.spend ?? 0), 0)
    const totalImpressions = allCampaigns.reduce((s, c) => s + (c.impressions ?? 0), 0)
    const avgRoas = active.length
      ? active.reduce((s, c) => s + (c.roas ?? 0), 0) / active.length
      : 0
    ads = {
      totalSpend,
      totalImpressions,
      avgRoas,
      activeCampaigns: active.length,
      total: allCampaigns.length,
    }
  }

  return NextResponse.json({
    connected: true,
    social: Object.values(platformLatest),
    pipeline: { ...pipelineCounts, scheduledSoon },
    ads,
  })
}
