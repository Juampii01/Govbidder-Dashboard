"use client"

import { useState } from "react"
import Link from "next/link"
import { BarChart3, DollarSign, Users2, LayoutGrid, FileBarChart } from "lucide-react"
import { cn } from "@/lib/utils"

// Panel (composición del antiguo /dashboard)
import { BusinessKPIs }      from "@/components/sections/business-kpis"
import { Profitability }     from "@/components/sections/profitability"
import { MoMPanel }          from "@/components/sections/mom-panel"
import { Projections }       from "@/components/sections/projections"
import { CorrelationChart }  from "@/components/sections/correlation-chart"
import { TrendCharts }       from "@/components/sections/trend-charts"
// Vistas existentes
import { SalesView }              from "@/components/views/sales-view"
import { MetricsView }            from "@/components/views/metrics-view"
import { PersonasAgendadasView }  from "@/components/views/personas-agendadas-view"

type Tab = "panel" | "ventas" | "agendadas" | "metricas"

const TABS: { id: Tab; label: string; icon: any; desc: string }[] = [
  { id: "panel",     label: "Panel",     icon: BarChart3, desc: "Resumen ejecutivo del negocio" },
  { id: "ventas",    label: "Ventas",    icon: DollarSign, desc: "Llamadas, cierres y números del mes" },
  { id: "agendadas", label: "Agendadas", icon: Users2,    desc: "Pipeline de personas agendadas" },
  { id: "metricas",  label: "Métricas",  icon: LayoutGrid, desc: "Todas las métricas en detalle" },
]

function PanelContent() {
  return (
    <div className="space-y-14">
      <BusinessKPIs />
      <Profitability />
      <Projections />
      <MoMPanel />
      <CorrelationChart />
      <TrendCharts />
    </div>
  )
}

export function PerformanceView({ initialTab = "panel" }: { initialTab?: string }) {
  const valid = TABS.some((t) => t.id === initialTab) ? (initialTab as Tab) : "panel"
  const [tab, setTab] = useState<Tab>(valid)

  const current = TABS.find((t) => t.id === tab)!

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Performance</h1>
          <p className="text-[13px] text-slate-500 mt-0.5">{current.desc}</p>
        </div>
        <Link
          href="/admin/reports"
          className="inline-flex items-center gap-2 rounded-xl bg-[#1e3a8a] px-3.5 py-2 text-[13px] font-semibold text-white hover:bg-[#1e3a8a]/90 transition-colors"
        >
          <FileBarChart className="h-4 w-4" />
          Cargar reporte
        </Link>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 overflow-x-auto rounded-xl border border-slate-200 bg-white p-1">
        {TABS.map((t) => {
          const Icon = t.icon
          const active = tab === t.id
          return (
            <button
              key={t.id}
              onClick={() => setTab(t.id)}
              className={cn(
                "flex items-center gap-2 whitespace-nowrap rounded-lg px-3.5 py-2 text-[13px] font-medium transition-all",
                active
                  ? "bg-[#1e3a8a]/[0.10] text-[#1e3a8a] font-semibold"
                  : "text-slate-500 hover:bg-slate-50 hover:text-slate-800",
              )}
            >
              <Icon className="h-4 w-4" />
              {t.label}
            </button>
          )
        })}
      </div>

      {/* Content */}
      <div>
        {tab === "panel"     && <PanelContent />}
        {tab === "ventas"    && <SalesView />}
        {tab === "agendadas" && <PersonasAgendadasView />}
        {tab === "metricas"  && <MetricsView />}
      </div>
    </div>
  )
}
