"use client"

/**
 * Reemplazo del confirm() nativo del browser, con el estilo del producto.
 *
 * Uso:
 *   const { confirm, dialog } = useConfirm()
 *   ...
 *   const ok = await confirm({
 *     title: "¿Borrar el form?",
 *     message: "Esto también borra todos sus submissions.",
 *     confirmLabel: "Borrar",
 *     destructive: true,
 *   })
 *   if (!ok) return
 *   ...
 *   return (<> ... {dialog} </>)
 */

import { useCallback, useRef, useState } from "react"
import { AlertTriangle } from "lucide-react"
import { Portal } from "@/components/ui/portal"

export interface ConfirmOptions {
  title:         string
  message?:      string
  confirmLabel?: string
  cancelLabel?:  string
  /** true → botón rojo (borrar/irreversible); false → azul marca. */
  destructive?:  boolean
}

export function useConfirm() {
  const [opts, setOpts] = useState<ConfirmOptions | null>(null)
  const resolverRef = useRef<((ok: boolean) => void) | null>(null)

  const confirm = useCallback((options: ConfirmOptions): Promise<boolean> => {
    setOpts(options)
    return new Promise<boolean>(resolve => { resolverRef.current = resolve })
  }, [])

  const close = useCallback((ok: boolean) => {
    resolverRef.current?.(ok)
    resolverRef.current = null
    setOpts(null)
  }, [])

  const dialog = opts ? (
    <Portal>
      <div className="fixed inset-0 z-[200] bg-slate-900/40 backdrop-blur-sm" onClick={() => close(false)} />
      <div className="fixed left-1/2 top-1/2 z-[210] w-[calc(100%-2rem)] max-w-sm -translate-x-1/2 -translate-y-1/2 rounded-2xl border border-border bg-popover p-6 shadow-[0_30px_80px_rgba(15,23,42,0.25)]">
        <div className="flex items-start gap-3.5">
          <span className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-xl ${
            opts.destructive ? "bg-[#E42D2C]/10 text-[#E42D2C]" : "bg-[#1e3a8a]/10 text-[#1e3a8a]"
          }`}>
            <AlertTriangle className="h-5 w-5" />
          </span>
          <div className="min-w-0">
            <p className="text-[15px] font-bold text-foreground leading-snug">{opts.title}</p>
            {opts.message && (
              <p className="mt-1.5 text-[13px] leading-relaxed text-muted-foreground">{opts.message}</p>
            )}
          </div>
        </div>
        <div className="mt-6 flex items-center justify-end gap-2">
          <button
            onClick={() => close(false)}
            className="h-9 rounded-xl border border-border bg-card px-4 text-[13px] font-semibold text-muted-foreground hover:text-foreground hover:bg-muted transition-colors"
          >
            {opts.cancelLabel ?? "Cancelar"}
          </button>
          <button
            onClick={() => close(true)}
            autoFocus
            className={`h-9 rounded-xl px-4 text-[13px] font-bold text-white transition-colors ${
              opts.destructive
                ? "bg-[#E42D2C] hover:bg-[#c42423]"
                : "bg-[#1e3a8a] hover:bg-[#1e3a8a]/90"
            }`}
          >
            {opts.confirmLabel ?? "Confirmar"}
          </button>
        </div>
      </div>
    </Portal>
  ) : null

  return { confirm, dialog }
}
