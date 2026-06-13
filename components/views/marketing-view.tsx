"use client"

import { ExternalLink } from "lucide-react"

const CONTENT_DASHBOARD_URL =
  process.env.NEXT_PUBLIC_CONTENT_DASHBOARD_URL ??
  "https://content-dashboard-coral.vercel.app"

export function ContenidoView() {
  return (
    // Negative margin para escapar el padding del DashboardLayout (p-4 / lg:p-8)
    <div className="-m-4 lg:-m-8 flex flex-col" style={{ height: "calc(100vh - 64px)" }}>
      {/* Barra mínima con link de escape */}
      <div className="flex items-center justify-end gap-2 px-4 py-1.5 border-b border-slate-200 bg-white shrink-0">
        <a
          href={CONTENT_DASHBOARD_URL}
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-1.5 text-[11px] text-slate-400 hover:text-slate-700 transition-colors"
        >
          <ExternalLink className="h-3 w-3" />
          Abrir en pestaña
        </a>
      </div>

      <iframe
        src={CONTENT_DASHBOARD_URL}
        className="flex-1 w-full border-0"
        title="Content Dashboard"
        allow="clipboard-read; clipboard-write"
      />
    </div>
  )
}
