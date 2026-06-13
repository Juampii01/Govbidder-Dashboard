"use client"

import { useEffect, useState } from "react"
import { createClient } from "@/lib/supabase"
import {
  Instagram, Youtube, Music2, TrendingUp, TrendingDown,
  LayoutList, CalendarCheck, Megaphone, ExternalLink, RefreshCw,
} from "lucide-react"

// ─── Types ────────────────────────────────────────────────────────────────────

interface SocialSnapshot {
  platform:       string
  followers:      number
  totalViews:     number
  engagementRate: number
  newFollowers:   number
  date:           string
}

interface PipelineCounts {
  drafts?:       number
  "en-proceso"?: number
  programado?:   number
  publicado?:    number
  scheduledSoon?: number
}

interface AdsData {
  totalSpend:       number
  totalImpressions: number
  avgRoas:          number
  activeCampaigns:  number
  total:            number
}

interface Summary {
  connected: boolean
  social:    SocialSnapshot[]
  pipeline:  PipelineCounts
  ads:       AdsData | null
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

const PLATFORMS: Record<string, { label: string; Icon: any; color: string }> = {
  instagram: { label: "Instagram", Icon: Instagram, color: "#E1306C" },
  youtube:   { label: "YouTube",   Icon: Youtube,   color: "#FF0000" },
  tiktok:    { label: "TikTok",    Icon: Music2,    color: "#010101" },
}

const PIPELINE_STEPS = [
  { key: "drafts",     label: "Borradores",  bar: "bg-slate-300"    },
  { key: "en-proceso", label: "En proceso",  bar: "bg-amber-400"    },
  { key: "programado", label: "Programados", bar: "bg-blue-500"     },
  { key: "publicado",  label: "Publicados",  bar: "bg-emerald-500"  },
]

function fmt(n: number) {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000)     return `${(n / 1_000).toFixed(1)}K`
  return n.toLocaleString()
}

// ─── Sub-components ───────────────────────────────────────────────────────────

function SectionTitle({ children }: { children: React.ReactNode }) {
  return (
    <h3 className="text-[11px] font-bold uppercase tracking-[0.15em] text-slate-400 mb-3">
      {children}
    </h3>
  )
}

function KpiCard({ label, value, sub, accent }: {
  label:  string
  value:  string
  sub?:   string
  accent?: "up" | "down" | null
}) {
  return (
    <div className="rounded-xl border border-slate-200 bg-white p-4 flex flex-col gap-1.5">
      <p className="text-[10px] text-slate-400 font-medium leading-none">{label}</p>
      <p className="text-xl font-bold text-slate-900 tabular-nums leading-none">{value}</p>
      {sub && (
        <p className={`text-[11px] font-semibold leading-none flex items-center gap-1 ${
          accent === "up"   ? "text-emerald-600" :
          accent === "down" ? "text-red-500"     : "text-slate-400"
        }`}>
          {accent === "up"   && <TrendingUp   className="h-3 w-3" />}
          {accent === "down" && <TrendingDown  className="h-3 w-3" />}
          {sub}
        </p>
      )}
    </div>
  )
}

function SocialSection({ snaps }: { snaps: SocialSnapshot[] }) {
  return (
    <section>
      <SectionTitle>Redes Sociales</SectionTitle>
      <div className="space-y-4">
        {snaps.map(snap => {
          const meta = PLATFORMS[snap.platform] ?? { label: snap.platform, Icon: TrendingUp, color: "#64748b" }
          const { Icon } = meta
          const deltaSign = snap.newFollowers > 0 ? "up" : snap.newFollowers < 0 ? "down" : null

          return (
            <div key={snap.platform} className="rounded-2xl border border-slate-200 bg-white p-5">
              <div className="flex items-center gap-2 mb-4">
                <Icon className="h-4 w-4 shrink-0" style={{ color: meta.color }} />
                <span className="text-[13px] font-bold text-slate-800">{meta.label}</span>
                {snap.newFollowers !== 0 && (
                  <span className={`ml-auto text-[11px] font-bold ${
                    deltaSign === "up" ? "text-emerald-600" : "text-red-500"
                  }`}>
                    {snap.newFollowers > 0 ? "+" : ""}{fmt(snap.newFollowers)} seguidores
                  </span>
                )}
              </div>
              <div className="grid grid-cols-3 gap-3">
                <KpiCard
                  label="Seguidores"
                  value={fmt(snap.followers)}
                  sub={snap.newFollowers !== 0 ? `${snap.newFollowers > 0 ? "+" : ""}${fmt(snap.newFollowers)} este período` : undefined}
                  accent={deltaSign}
                />
                <KpiCard label="Views totales"  value={fmt(snap.totalViews)} />
                <KpiCard label="Engagement"     value={`${snap.engagementRate.toFixed(2)}%`} />
              </div>
            </div>
          )
        })}
      </div>
    </section>
  )
}

function PipelineSection({ pipeline }: { pipeline: PipelineCounts }) {
  const total = PIPELINE_STEPS.reduce((s, p) => s + ((pipeline as any)[p.key] ?? 0), 0)

  return (
    <section>
      <SectionTitle>Pipeline de Contenido</SectionTitle>
      <div className="rounded-2xl border border-slate-200 bg-white p-5 space-y-4">
        <div className="flex items-center justify-between text-[12px]">
          <span className="flex items-center gap-2 text-slate-600 font-medium">
            <LayoutList className="h-4 w-4 text-slate-400" />
            {total} piezas en total
          </span>
          {(pipeline.scheduledSoon ?? 0) > 0 && (
            <span className="flex items-center gap-1.5 text-blue-600 font-semibold">
              <CalendarCheck className="h-3.5 w-3.5" />
              {pipeline.scheduledSoon} esta semana
            </span>
          )}
        </div>

        {/* Barra de progreso visual */}
        {total > 0 && (
          <div className="flex h-2 rounded-full overflow-hidden gap-0.5">
            {PIPELINE_STEPS.map(step => {
              const count = (pipeline as any)[step.key] ?? 0
              const pct   = (count / total) * 100
              if (!count) return null
              return (
                <div
                  key={step.key}
                  className={`${step.bar} rounded-full`}
                  style={{ width: `${pct}%` }}
                  title={`${step.label}: ${count}`}
                />
              )
            })}
          </div>
        )}

        <div className="grid grid-cols-4 gap-3">
          {PIPELINE_STEPS.map(step => (
            <div key={step.key} className="flex flex-col gap-1">
              <div className={`h-0.5 w-6 rounded-full ${step.bar}`} />
              <p className="text-lg font-bold text-slate-900 tabular-nums">
                {(pipeline as any)[step.key] ?? 0}
              </p>
              <p className="text-[10px] text-slate-400">{step.label}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

function AdsSection({ ads }: { ads: AdsData }) {
  return (
    <section>
      <SectionTitle>Meta Ads</SectionTitle>
      <div className="rounded-2xl border border-slate-200 bg-white p-5">
        <div className="flex items-center gap-2 mb-4">
          <Megaphone className="h-4 w-4 text-slate-400" />
          <span className="text-[13px] font-bold text-slate-800">
            {ads.total} campaña{ads.total !== 1 ? "s" : ""}
          </span>
          {ads.activeCampaigns > 0 && (
            <span className="ml-auto text-[11px] font-bold text-emerald-600">
              {ads.activeCampaigns} activa{ads.activeCampaigns !== 1 ? "s" : ""}
            </span>
          )}
        </div>
        <div className="grid grid-cols-3 gap-3">
          <KpiCard
            label="Gasto total"
            value={`$${ads.totalSpend >= 1000 ? (ads.totalSpend / 1000).toFixed(1) + "K" : ads.totalSpend.toFixed(0)}`}
          />
          <KpiCard label="Impresiones" value={fmt(ads.totalImpressions)} />
          <KpiCard label="ROAS prom."  value={`${ads.avgRoas.toFixed(2)}x`} />
        </div>
      </div>
    </section>
  )
}

function Skeleton() {
  return (
    <div className="space-y-6 animate-pulse">
      {[1, 2, 3].map(i => (
        <div key={i} className="rounded-2xl border border-slate-200 bg-white p-5">
          <div className="h-4 w-32 bg-slate-100 rounded mb-4" />
          <div className="grid grid-cols-3 gap-3">
            {[1, 2, 3].map(j => (
              <div key={j} className="space-y-2">
                <div className="h-5 w-16 bg-slate-100 rounded" />
                <div className="h-3 w-12 bg-slate-100 rounded" />
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  )
}

// ─── Main ─────────────────────────────────────────────────────────────────────

export function MarketingKPIsView() {
  const [data,    setData]    = useState<Summary | null>(null)
  const [loading, setLoading] = useState(true)
  const [error,   setError]   = useState<string | null>(null)

  async function load() {
    try {
      setLoading(true); setError(null)
      const supabase = createClient()
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) { setError("Sin sesión"); setLoading(false); return }

      const res = await fetch("/api/marketing/summary", {
        headers: { Authorization: `Bearer ${session.access_token}` },
      })
      if (!res.ok) throw new Error(`Error ${res.status}`)
      setData(await res.json())
    } catch (e: any) {
      setError(e?.message ?? "Error desconocido")
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => { load() }, [])

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-slate-900">Marketing</h2>
          <p className="text-[13px] text-slate-400 mt-0.5">KPIs de redes sociales, contenido y ads</p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={load}
            disabled={loading}
            className="flex items-center gap-1.5 text-[12px] text-slate-400 hover:text-slate-700 transition-colors disabled:opacity-40"
          >
            <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
            Actualizar
          </button>
          <a
            href="https://content-dashboard-coral.vercel.app"
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center gap-1.5 text-[12px] text-slate-400 hover:text-slate-700 transition-colors"
          >
            <ExternalLink className="h-3.5 w-3.5" />
            Content Dashboard
          </a>
        </div>
      </div>

      {loading && <Skeleton />}

      {!loading && error && (
        <div className="rounded-2xl border border-red-200 bg-red-50 p-4 text-[13px] text-red-600">
          {error}
        </div>
      )}

      {!loading && !error && data && !data.connected && (
        <div className="rounded-2xl border border-slate-200 bg-white p-8 flex flex-col items-center gap-3 text-center">
          <TrendingUp className="h-8 w-8 text-slate-300" />
          <p className="text-[14px] font-semibold text-slate-600">Sin datos de Content Dashboard</p>
          <p className="text-[12px] text-slate-400 max-w-xs">
            Tu usuario no está vinculado a un workspace en el Content Dashboard.
          </p>
        </div>
      )}

      {!loading && !error && data?.connected && (
        <div className="space-y-8">
          {data.social.length > 0 && <SocialSection snaps={data.social} />}
          <PipelineSection pipeline={data.pipeline} />
          {data.ads && <AdsSection ads={data.ads} />}
        </div>
      )}
    </div>
  )
}
