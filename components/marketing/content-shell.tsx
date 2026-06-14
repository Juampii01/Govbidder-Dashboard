"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import Image from "next/image"
import { usePathname, useRouter } from "next/navigation"
import { Toaster } from "sonner"
import { createClient } from "@/lib/supabase"
import { useTheme } from "@/components/ui/theme-provider"
import { cn } from "@/lib/utils"
import { BRANDS, type BrandId } from "@/lib/marketing/brands"
import {
  ArrowLeft, Megaphone, Instagram, Youtube, Music2, MonitorPlay,
  Palette, Search, FlaskConical, MessageSquare, LayoutList, Database,
  X, Menu, Sun, Moon,
} from "lucide-react"

// ─── Brand switcher (Santo / Tío Sam) ──────────────────────────────────────────

function BrandSwitcher() {
  const router = useRouter()
  const [active, setActive] = useState<BrandId | null>(null)
  const [busy, setBusy] = useState(false)

  useEffect(() => {
    fetch("/api/marketing/brand")
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => d && setActive(d.active))
      .catch(() => {})
  }, [])

  async function select(id: BrandId) {
    if (id === active || busy) return
    setBusy(true)
    try {
      await fetch("/api/marketing/brand", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ brandId: id }),
      })
      setActive(id)
      router.refresh()
    } finally {
      setBusy(false)
    }
  }

  return (
    <div className="px-3 pt-3">
      <p className="px-1 mb-1.5 text-[10px] font-bold uppercase tracking-[0.15em] text-muted-foreground">Marca</p>
      <div className="flex gap-1 rounded-xl bg-muted p-1">
        {BRANDS.map((b) => (
          <button
            key={b.id}
            onClick={() => select(b.id)}
            disabled={busy}
            className={cn(
              "flex-1 rounded-lg px-2 py-1.5 text-[12px] font-semibold transition-all disabled:opacity-60",
              active === b.id
                ? "bg-card text-[#1e3a8a] dark:text-[#9db8ff] shadow-sm"
                : "text-muted-foreground hover:text-foreground",
            )}
          >
            {b.name}
          </button>
        ))}
      </div>
    </div>
  )
}

// ─── Nav model ─────────────────────────────────────────────────────────────────

interface NavItem { name: string; href: string; icon: any }

const NAV: { label: string; items: NavItem[] }[] = [
  {
    label: "Resumen",
    items: [
      { name: "KPIs", href: "/marketing", icon: Megaphone },
    ],
  },
  {
    label: "Analytics",
    items: [
      { name: "Instagram", href: "/marketing/instagram", icon: Instagram   },
      { name: "YouTube",   href: "/marketing/youtube",   icon: Youtube     },
      { name: "TikTok",    href: "/marketing/tiktok",    icon: Music2      },
      { name: "Ads",       href: "/marketing/ads",       icon: MonitorPlay },
    ],
  },
  {
    label: "Crear",
    items: [
      { name: "Estudio de Contenido", href: "/marketing/contenido",     icon: Palette      },
      { name: "Investigación",        href: "/marketing/investigacion", icon: Search       },
      { name: "Analizador",           href: "/marketing/analizador",    icon: FlaskConical },
      { name: "AI",                   href: "/marketing/ai",            icon: MessageSquare },
    ],
  },
  {
    label: "Organizar",
    items: [
      { name: "Tareas", href: "/marketing/tareas", icon: LayoutList },
      { name: "Bases",  href: "/marketing/bases",  icon: Database   },
    ],
  },
]

// ─── Shell ──────────────────────────────────────────────────────────────────────

export function ContentShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname()
  const router = useRouter()
  const { setTheme, resolvedTheme } = useTheme()
  const [authChecked, setAuthChecked] = useState(false)
  const [mobileOpen, setMobileOpen] = useState(false)

  // Auth guard — same behavior as the main dashboard shell.
  useEffect(() => {
    const supabase = createClient()
    let mounted = true
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!mounted) return
      if (!session) { router.replace("/login"); return }
      setAuthChecked(true)
    })
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_e, session) => {
      if (!session) router.replace("/login")
    })
    return () => { mounted = false; subscription.unsubscribe() }
  }, [router])

  // Close mobile drawer on route change
  useEffect(() => { setMobileOpen(false) }, [pathname])

  if (!authChecked) {
    return (
      <div className="flex h-screen items-center justify-center bg-card">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-border border-t-[#E42D2C]" />
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background">
      <Toaster position="top-right" richColors />

      {/* Mobile overlay */}
      {mobileOpen && (
        <div className="fixed inset-0 z-40 bg-slate-900/30 backdrop-blur-sm lg:hidden" onClick={() => setMobileOpen(false)} />
      )}

      {/* Sidebar */}
      <aside className={cn(
        "fixed left-0 top-0 z-50 h-full w-[240px] flex flex-col bg-card border-r-2 border-border",
        "transition-transform duration-300 ease-out",
        mobileOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0",
      )}>
        {/* Brand */}
        <div className="relative flex h-16 flex-shrink-0 items-center border-b-2 border-border px-4">
          <Link href="/marketing" className="flex items-center gap-2 hover:opacity-90">
            <Image src="/icon.png" alt="Content" width={160} height={120} className="h-10 w-auto object-contain" priority />
          </Link>
          {/* Theme toggle (desktop) — sincronizado con el dashboard principal */}
          <button
            onClick={() => setTheme(resolvedTheme === "dark" ? "light" : "dark")}
            title={resolvedTheme === "dark" ? "Cambiar a claro" : "Cambiar a oscuro"}
            aria-label="Cambiar tema"
            className="hidden lg:flex absolute right-3 h-8 w-8 items-center justify-center rounded-lg text-muted-foreground hover:bg-muted hover:text-foreground transition-colors"
          >
            {resolvedTheme === "dark" ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
          </button>
          <button className="lg:hidden absolute right-3 flex h-8 w-8 items-center justify-center rounded-lg text-muted-foreground hover:bg-muted"
            onClick={() => setMobileOpen(false)} aria-label="Cerrar">
            <X className="h-4 w-4" />
          </button>
        </div>

        {/* Back to main dashboard */}
        <div className="px-3 pt-3">
          <Link href="/inicio"
            className="flex items-center gap-2 rounded-xl border border-border px-3 py-2 text-[13px] font-medium text-muted-foreground hover:bg-muted hover:text-foreground transition-colors">
            <ArrowLeft className="h-4 w-4" />
            Volver a GovBidder
          </Link>
        </div>

        {/* Selector de marca (Santo / Tío Sam) — compartido por el equipo */}
        <BrandSwitcher />

        {/* Nav */}
        <nav className="flex-1 overflow-y-auto px-3 py-4 space-y-5">
          {NAV.map(group => (
            <div key={group.label}>
              <p className="px-3 mb-1.5 text-[10px] font-bold uppercase tracking-[0.18em] text-[#1e3a8a]/70 dark:text-muted-foreground">{group.label}</p>
              <div className="space-y-0.5">
                {group.items.map(item => {
                  const active = pathname === item.href || pathname?.startsWith(item.href + "/")
                  const Icon = item.icon
                  return (
                    <Link key={item.href} href={item.href}
                      className={cn(
                        "group relative flex items-center gap-2.5 rounded-xl px-3 py-2 text-[13px] transition-all",
                        active ? "bg-[#1e3a8a]/[0.10] dark:bg-[#3b5bdb]/25 text-[#1e3a8a] dark:text-[#9db8ff] font-semibold"
                               : "text-muted-foreground hover:bg-muted hover:text-foreground font-medium",
                      )}>
                      {active && <span className="absolute left-0 top-1/2 h-6 w-[3px] -translate-y-1/2 rounded-r-full bg-[#1e3a8a] dark:bg-[#9db8ff]" />}
                      <Icon className={cn("h-4 w-4 shrink-0", active ? "text-[#1e3a8a] dark:text-[#9db8ff]" : "text-muted-foreground group-hover:text-muted-foreground")} />
                      <span className="truncate leading-none">{item.name}</span>
                    </Link>
                  )
                })}
              </div>
            </div>
          ))}
        </nav>

        <div className="px-4 py-3 border-t border-border">
          <p className="text-[10px] text-muted-foreground">Content Dashboard · GovBidder</p>
        </div>
      </aside>

      {/* Main */}
      <div className="lg:ml-[240px] flex min-h-screen flex-col">
        {/* Mobile top bar with menu toggle */}
        <div className="lg:hidden sticky top-0 z-30 flex h-14 items-center gap-3 border-b border-border bg-card px-4">
          <button onClick={() => setMobileOpen(true)} className="flex h-9 w-9 items-center justify-center rounded-lg text-muted-foreground hover:bg-muted" aria-label="Menú">
            <Menu className="h-5 w-5" />
          </button>
          <span className="text-[14px] font-bold text-foreground">Content Dashboard</span>
        </div>

        <main className="flex-1">
          <div className="p-4 lg:p-8 max-w-[1600px] mx-auto">
            {children}
          </div>
        </main>
      </div>
    </div>
  )
}
