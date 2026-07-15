-- ═══════════════════════════════════════════════════════════════════════════
-- RLS hardening: habilitar Row Level Security en tablas que quedaron expuestas.
--
-- Contexto: las tablas del Content Dashboard (schema Prisma, PascalCase) se
-- crearon en 20260614000001 SIN RLS. En Supabase, toda tabla de `public` es
-- accesible vía PostgREST con la anon key salvo que RLS la bloquee — esto
-- incluía "SocialConnection" (tokens OAuth de IG/YT/TikTok) y "OAuthState".
--
-- Fix: ENABLE ROW LEVEL SECURITY sin policies = deny-all para anon y
-- authenticated vía PostgREST. NO afecta a la app:
--   * Prisma conecta como rol `postgres` (owner de las tablas → bypasea RLS).
--   * El service client de las API routes usa service_role (bypasea RLS).
--
-- También cierra ai_diagnosis_requests / ai_diagnosis_results (hallazgo de la
-- auditoría 2026-05-10 que seguía abierto). IF EXISTS porque cleanup_phase1
-- puede haberlas dropeado.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Tablas legacy sin RLS ────────────────────────────────────────────────────
alter table if exists public.ai_diagnosis_requests enable row level security;
alter table if exists public.ai_diagnosis_results  enable row level security;

-- ── Tablas del Content Dashboard (Prisma) ────────────────────────────────────
alter table if exists public."AIMessage"              enable row level security;
alter table if exists public."AccountSnapshot"        enable row level security;
alter table if exists public."AdAccount"              enable row level security;
alter table if exists public."AdCampaign"             enable row level security;
alter table if exists public."Analysis"               enable row level security;
alter table if exists public."AudienceSnapshot"       enable row level security;
alter table if exists public."BusinessBase"           enable row level security;
alter table if exists public."ChatMessage"            enable row level security;
alter table if exists public."Client"                 enable row level security;
alter table if exists public."Competitor"             enable row level security;
alter table if exists public."ContentPiece"           enable row level security;
alter table if exists public."ContentResearchHistory" enable row level security;
alter table if exists public."ContentTemplate"        enable row level security;
alter table if exists public."Conversation"           enable row level security;
alter table if exists public."GuionItem"              enable row level security;
alter table if exists public."GuionTab"               enable row level security;
alter table if exists public."ICPProfile"             enable row level security;
alter table if exists public."IGConversation"         enable row level security;
alter table if exists public."IGMessage"              enable row level security;
alter table if exists public."Idea"                   enable row level security;
alter table if exists public."IncomeRecord"           enable row level security;
alter table if exists public."InstagramComment"       enable row level security;
alter table if exists public."OAuthState"             enable row level security;
alter table if exists public."Profile"                enable row level security;
alter table if exists public."PublishedPost"          enable row level security;
alter table if exists public."Reel"                   enable row level security;
alter table if exists public."ScrapeJob"              enable row level security;
alter table if exists public."SocialConnection"       enable row level security;
alter table if exists public."Story"                  enable row level security;
alter table if exists public."Task"                   enable row level security;
alter table if exists public."TikTokVideo"            enable row level security;
alter table if exists public."TranscriptHistory"      enable row level security;
alter table if exists public."Transcription"          enable row level security;
alter table if exists public."UserReel"               enable row level security;
alter table if exists public."VideoFeedAccount"       enable row level security;
alter table if exists public."YouTubeVideo"           enable row level security;
