"use client";

import { useState } from "react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase";

function isAlreadyRegisteredError(error: any) {
  const msg = String(error?.message ?? "");
  const code = String(error?.code ?? "");
  if (["user_already_exists", "email_exists", "email_already_exists"].includes(code)) return true;
  return /already\s*(registered|been\s*registered)|user\s*already\s*registered|email\s*already\s*(registered|in\s*use)|duplicate/i.test(
    msg
  );
}

export default function SignupPage() {
  const router = useRouter();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  const [msg, setMsg] = useState<string | null>(null);

  const [pendingConfirmEmail, setPendingConfirmEmail] = useState<string | null>(null);
  const [pendingRedirectTo, setPendingRedirectTo] = useState<string | null>(null);
  const [resendLoading, setResendLoading] = useState(false);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();

    setLoading(true);
    setErr(null);
    setMsg(null);

    setPendingConfirmEmail(null);
    setPendingRedirectTo(null);
    setResendLoading(false);

    const supabase = createClient();

    const cleanEmail = email.trim().toLowerCase();

    if (!cleanEmail.includes("@")) {
      setLoading(false);
      setErr("Ingresá un email válido.");
      return;
    }
    if (password.length < 6) {
      setLoading(false);
      setErr("La contraseña debe tener al menos 6 caracteres.");
      return;
    }

    const emailRedirectTo = `${window.location.origin}/login`;

    const { data, error } = await supabase.auth.signUp({
      email: cleanEmail,
      password,
      options: {
        emailRedirectTo,
      },
    });

    if (error) {
      if (isAlreadyRegisteredError(error)) {
        const { error: resendErr } = await supabase.auth.resend({
          type: "signup",
          email: cleanEmail,
          options: {
            emailRedirectTo,
          },
        });

        setLoading(false);

        if (!resendErr) {
          setMsg(
            "Ese email ya tiene una cuenta, pero puede que no esté confirmado. Te reenviamos el email de verificación (revisá spam/promociones). Si ya confirmaste, iniciá sesión."
          );
          return;
        }

        setErr(
          `No pude crear la cuenta. Supabase devolvió un error de duplicado, pero no pude reenviar el mail de confirmación. Detalle: ${String(
            resendErr.message ?? resendErr
          )}`
        );
        return;
      }

      setLoading(false);
      setErr(String(error.message ?? error));
      return;
    }

    if (!data?.user?.id) {
      setLoading(false);
      setErr("No pude confirmar la creación del usuario. Conectate con soporte (envia captura).");
      return;
    }

    if (!data?.session) {
      setLoading(false);
      setPendingConfirmEmail(cleanEmail);
      setPendingRedirectTo(emailRedirectTo);
      setMsg(
        "Cuenta creada, pero falta confirmar el email. Revisá spam/promociones. Si no te llegó, podés reenviarlo desde acá."
      );
      return;
    }

    const { data: sessionData } = await supabase.auth.getSession();
    if (!sessionData?.session?.user?.id) {
      setLoading(false);
      setErr("La cuenta parece creada, pero no pude leer la sesión. Conectate con soporte (envia captura).");
      return;
    }

    setLoading(false);
    setMsg("Cuenta creada y sesión iniciada. Redirigiendo...");
    setTimeout(() => router.push("/"), 600);
  }

  async function onResendConfirmation() {
    if (!pendingConfirmEmail) return;

    setResendLoading(true);
    setErr(null);
    setMsg(null);

    const supabase = createClient();
    const emailRedirectTo = pendingRedirectTo || `${window.location.origin}/login`;

    const { error: resendErr } = await supabase.auth.resend({
      type: "signup",
      email: pendingConfirmEmail,
      options: { emailRedirectTo },
    });

    setResendLoading(false);

    if (resendErr) {
      setErr(`No pude reenviar el email de confirmación. Detalle: ${String(resendErr.message ?? resendErr)}`);
      return;
    }

    setMsg("Listo: reenvié el email de confirmación. Revisá spam/promociones y abrí el link desde la misma pestaña/host.");
  }

  return (
    <div className="min-h-screen bg-white flex items-center justify-center px-6 py-12 relative overflow-hidden">

      {/* Subtle ambient backdrop */}
      <div className="pointer-events-none absolute inset-0">
        <div className="absolute top-0 left-1/2 -translate-x-1/2 h-[500px] w-[500px] rounded-full bg-[#E42D2C]/[0.05] blur-[160px]" />
        <div className="absolute bottom-0 left-1/4 h-[400px] w-[400px] rounded-full bg-[#1e3a8a]/[0.04] blur-[140px]" />
      </div>

      <div className="relative w-full max-w-[400px]">

        {/* Logo */}
        <div className="mb-8 flex justify-center">
          <Image
            src="/icon.png"
            alt="GovBidder · The Bid That Wins"
            width={260}
            height={200}
            className="h-auto w-[220px] object-contain"
            priority
          />
        </div>

        {/* Card */}
        <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-[0_20px_60px_rgba(15,23,42,0.08)]">

          <div className="mb-7 text-center">
            <h1 className="text-[22px] font-bold tracking-tight text-slate-900">Crear cuenta</h1>
            <p className="mt-1.5 text-[13px] text-slate-500">
              Creá tu acceso y confirmá el email para continuar.
            </p>
          </div>

          <form onSubmit={onSubmit} className="space-y-4">

            <div className="space-y-1.5">
              <label className="block text-[11px] font-semibold uppercase tracking-widest text-slate-500">
                Email
              </label>
              <input
                className="h-12 w-full rounded-xl border border-slate-200 bg-white px-4 text-sm text-slate-900 outline-none placeholder:text-slate-400 transition-all focus:border-[#E42D2C] focus:ring-2 focus:ring-[#E42D2C]/15"
                placeholder="tu@email.com"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                autoComplete="email"
                autoFocus
              />
            </div>

            <div className="space-y-1.5">
              <label className="block text-[11px] font-semibold uppercase tracking-widest text-slate-500">
                Contraseña
              </label>
              <input
                className="h-12 w-full rounded-xl border border-slate-200 bg-white px-4 text-sm text-slate-900 outline-none placeholder:text-slate-400 transition-all focus:border-[#E42D2C] focus:ring-2 focus:ring-[#E42D2C]/15"
                placeholder="Mínimo 6 caracteres"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={6}
                autoComplete="new-password"
              />
            </div>

            {err && (
              <div className="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-[12px] leading-relaxed text-red-700">
                {err}
              </div>
            )}

            {msg && (
              <div className="rounded-xl border border-[#1e3a8a]/20 bg-[#1e3a8a]/[0.04] px-4 py-3 text-[12px] leading-relaxed text-[#1e3a8a]">
                {msg}
              </div>
            )}

            {pendingConfirmEmail && (
              <button
                type="button"
                onClick={onResendConfirmation}
                disabled={resendLoading}
                className="h-12 w-full rounded-full border border-slate-200 bg-white text-sm font-semibold text-slate-700 transition-all hover:border-[#E42D2C]/40 hover:text-[#E42D2C] disabled:opacity-50"
              >
                {resendLoading ? "Reenviando…" : "Reenviar email de confirmación"}
              </button>
            )}

            <button
              type="submit"
              disabled={loading}
              className="mt-2 h-12 w-full rounded-full bg-[#E42D2C] text-sm font-bold text-white transition-all hover:bg-[#c42423] hover:shadow-[0_8px_24px_rgba(228,45,44,0.30)] disabled:opacity-50 active:scale-[0.98]"
            >
              {loading ? (
                <span className="flex items-center justify-center gap-2">
                  <span className="h-4 w-4 animate-spin rounded-full border-2 border-white/40 border-t-white" />
                  Creando…
                </span>
              ) : (
                "Crear cuenta"
              )}
            </button>
          </form>

          <div className="mt-7 flex items-center justify-between text-[11px]">
            <a href="/login" className="text-slate-500 transition-colors hover:text-[#E42D2C]">
              Ya tengo cuenta → Iniciar sesión
            </a>
            <a href="/forgot-password" className="text-slate-500 transition-colors hover:text-[#E42D2C]">
              ¿Olvidaste tu contraseña?
            </a>
          </div>
        </div>

        <p className="mt-8 text-center text-[10px] uppercase tracking-[0.22em] text-slate-300">
          © {new Date().getFullYear()} GovBidder · The Bid That Wins
        </p>
      </div>
    </div>
  );
}