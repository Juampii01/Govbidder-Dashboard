# GovBidder — Dashboard General

Centro de operaciones interno de GovBidder. La "vista de comando" del negocio: KPIs de ventas y contenido, tareas por departamento, agenda de llamadas, reportes mensuales y un asistente de AI — todo en un solo lugar, pensado para que el founder entienda cómo está el negocio en menos de 2 minutos.

> Herramienta interna del equipo. No es un CRM ni un portal para clientes finales.

## Módulos

| Módulo | Qué hace |
|---|---|
| **Inicio** | Snapshot de salud del negocio: tareas vencidas, personas sin seguimiento, métricas en baja, carga por departamento. |
| **Performance** | KPIs de negocio (revenue, MRR, llamadas, clientes) con comparativas mes a mes, proyecciones y rentabilidad. Incluye tabs de Ventas y Agendadas. |
| **Content** | Dashboard de contenido multi-marca (Instagram / YouTube / TikTok): métricas, competidores, guiones, transcripciones, AI. |
| **Operación** | Tareas por departamento (kanban + calendario + plantillas), actividad del equipo, Centro Operativo (SOPs y recursos). |
| **Configuración** (admin) | Equipo y roles, departamentos, forms públicos, reportes mensuales, audit log. |
| **AI Assistant** | Preguntas en lenguaje natural sobre el estado del negocio, redacción de emails, standups y extracción de tareas. |

## Stack

Next.js 16 (App Router, Turbopack) · React 19 · TypeScript 6 · Tailwind CSS 4 · Radix UI + shadcn/ui · Supabase (auth + Postgres con RLS) · Prisma (módulo Content) · Anthropic SDK · Resend · Recharts · Deploy en **Vercel**.

## Desarrollo

```bash
pnpm install
cp .env.example .env.local   # completar credenciales (ver comentarios del archivo)
pnpm dev                     # http://localhost:3000
```

Checks:

```bash
npx tsc --noEmit   # type check (el build también falla con errores de tipos)
pnpm lint          # ESLint
pnpm build         # build de producción
```

No hay test runner configurado — validar con typecheck + lint + smoke test manual.

## Variables de entorno

Ver [.env.example](.env.example) para la lista completa comentada. Las críticas:

- `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` / `SUPABASE_SERVICE_ROLE_KEY` — Supabase
- `ANTHROPIC_API_KEY` — features de AI
- `CRON_SECRET` — **requerida en producción**: los endpoints de cron devuelven 401 sin ella
- `DATABASE_URL` / `DIRECT_URL` — Prisma (módulo Content/Marketing)
- `RESEND_API_KEY` — email digest (opcional; sin ella los envíos se saltean)

## Base de datos

- Schema completo: [supabase/schema.sql](supabase/schema.sql) · migraciones incrementales en [supabase/migrations/](supabase/migrations/).
- **Toda tabla nueva debe nacer con `ENABLE ROW LEVEL SECURITY`.** Las tablas del módulo Content no tienen policies a propósito: se accede solo vía Prisma/service role.
- Gotcha conocido: nunca crear una policy en `profiles` que haga sub-query a `profiles` (recursión infinita). Usar la función `public.is_admin()` (SECURITY DEFINER).

## Autorización

- `proxy.ts` solo refresca la sesión — **no gatea rutas**. El gating de UI lo hacen los layouts, y el de datos lo hace **cada API route** con los helpers de [lib/api-auth.ts](lib/api-auth.ts) (`requireUser` / `requireAdmin`).
- Roles: `developer > super_admin > admin > user (empleado) > viewer` — ver [lib/types/role.ts](lib/types/role.ts).
- Las rutas usan el service client (bypasea RLS): el check de rol en la route es la única defensa. Toda ruta nueva debe usar los helpers.

## Crons (Vercel)

Definidos en [vercel.json](vercel.json), protegidos por `CRON_SECRET`:

| Endpoint | Schedule | Qué hace |
|---|---|---|
| `/api/cron/generate-recurring` | diario 06:00 UTC | instancia tareas recurrentes |
| `/api/cron/email-digest` | diario 12:00 UTC | digest de notificaciones por email |
| `/api/cron/monthly-report` | día 1, 10:00 UTC | reporte ejecutivo mensual a admins |

## Convenciones

Ver [CLAUDE.md](CLAUDE.md) para las convenciones completas de código, estructura y commits (`tipo(scope): descripción`).
