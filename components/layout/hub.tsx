import Link from "next/link"
import { ChevronRight } from "lucide-react"
import type { LucideIcon } from "lucide-react"

/**
 * Hub landing — patrón centralizado: entrás a una sección y elegís sub-destino
 * con tarjetas auto-explicativas. Reutilizable por Performance / Operación /
 * Configuración para mantener el sidebar mínimo. Usa tokens del tema (light/dark).
 */

export function HubHeader({ title, subtitle }: { title: string; subtitle?: string }) {
  return (
    <div className="mb-6">
      <h1 className="text-2xl font-bold text-foreground">{title}</h1>
      {subtitle && <p className="text-[14px] text-muted-foreground mt-1">{subtitle}</p>}
    </div>
  )
}

export function HubGrid({ children }: { children: React.ReactNode }) {
  return <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">{children}</div>
}

export function HubSection({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <section className="mb-8">
      <p className="mb-3 text-[11px] font-bold uppercase tracking-[0.15em] text-muted-foreground">{label}</p>
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
      className="group flex flex-col gap-3 rounded-2xl border border-border bg-card p-5 transition-all hover:border-[#1e3a8a]/30 dark:hover:border-[#3b5bdb]/50 hover:shadow-[0_8px_24px_rgba(15,23,42,0.06)]"
    >
      <div className="flex items-center justify-between">
        <span
          className="flex h-10 w-10 items-center justify-center rounded-xl"
          style={{ backgroundColor: `${color}22`, color }}
        >
          <Icon className="h-5 w-5" />
        </span>
        <ChevronRight className="h-4 w-4 text-muted-foreground/50 transition-all group-hover:translate-x-0.5 group-hover:text-[#1e3a8a] dark:group-hover:text-[#9db8ff]" />
      </div>
      <div>
        <h3 className="text-[15px] font-bold text-foreground">{title}</h3>
        <p className="mt-0.5 text-[12px] leading-snug text-muted-foreground">{desc}</p>
      </div>
    </Link>
  )
}
