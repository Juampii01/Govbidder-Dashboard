import Link from "next/link"
import { ChevronRight } from "lucide-react"
import type { LucideIcon } from "lucide-react"

/**
 * Hub landing — patrón centralizado: entrás a una sección y elegís sub-destino
 * con tarjetas auto-explicativas. Reutilizable por Performance / Operación /
 * Configuración para mantener el sidebar mínimo.
 */

export function HubHeader({ title, subtitle }: { title: string; subtitle?: string }) {
  return (
    <div className="mb-6">
      <h1 className="text-2xl font-bold text-slate-900">{title}</h1>
      {subtitle && <p className="text-[14px] text-slate-500 mt-1">{subtitle}</p>}
    </div>
  )
}

export function HubGrid({ children }: { children: React.ReactNode }) {
  return <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">{children}</div>
}

export function HubSection({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <section className="mb-8">
      <p className="mb-3 text-[11px] font-bold uppercase tracking-[0.15em] text-slate-400">{label}</p>
      <HubGrid>{children}</HubGrid>
    </section>
  )
}

export function HubCard({
  href, icon: Icon, title, desc, color = "#1e3a8a",
}: {
  href: string
  icon: LucideIcon
  title: string
  desc: string
  color?: string
}) {
  return (
    <Link
      href={href}
      className="group flex flex-col gap-3 rounded-2xl border border-slate-200 bg-white p-5 transition-all hover:border-[#1e3a8a]/30 hover:shadow-[0_8px_24px_rgba(15,23,42,0.06)]"
    >
      <div className="flex items-center justify-between">
        <span
          className="flex h-10 w-10 items-center justify-center rounded-xl"
          style={{ backgroundColor: `${color}15`, color }}
        >
          <Icon className="h-5 w-5" />
        </span>
        <ChevronRight className="h-4 w-4 text-slate-300 transition-all group-hover:translate-x-0.5 group-hover:text-[#1e3a8a]" />
      </div>
      <div>
        <h3 className="text-[15px] font-bold text-slate-900">{title}</h3>
        <p className="mt-0.5 text-[12px] leading-snug text-slate-500">{desc}</p>
      </div>
    </Link>
  )
}
