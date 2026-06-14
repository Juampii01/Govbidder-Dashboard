-- ============================================================
-- Content Dashboard tables — migración completa
-- Generado: Sun Jun 14 02:42:00 -03 2026
-- Estas tablas son para el Content Dashboard integrado en GovBidder
-- ============================================================


-- ── Migración: 20260420000000_init_postgres ──
-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE IF NOT EXISTS "Competitor" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "displayName" TEXT,
    "profilePicUrl" TEXT,
    "followersCount" INTEGER,
    "lastScrapedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Competitor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Reel" (
    "id" TEXT NOT NULL,
    "competitorId" TEXT NOT NULL,
    "instagramId" TEXT NOT NULL,
    "shortcode" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "thumbnailUrl" TEXT,
    "videoUrl" TEXT,
    "caption" TEXT,
    "viewsCount" INTEGER NOT NULL DEFAULT 0,
    "likesCount" INTEGER NOT NULL DEFAULT 0,
    "commentsCount" INTEGER NOT NULL DEFAULT 0,
    "sharesCount" INTEGER NOT NULL DEFAULT 0,
    "durationSec" DOUBLE PRECISION,
    "postedAt" TIMESTAMP(3),
    "scrapedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Reel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Transcription" (
    "id" TEXT NOT NULL,
    "reelId" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "language" TEXT NOT NULL,
    "provider" TEXT NOT NULL DEFAULT 'groq-whisper-v3-turbo',
    "costUsd" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Transcription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Analysis" (
    "id" TEXT NOT NULL,
    "reelId" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "painPoints" TEXT NOT NULL,
    "desires" TEXT NOT NULL,
    "problems" TEXT NOT NULL,
    "insights" TEXT NOT NULL,
    "keywords" TEXT NOT NULL,
    "inputTokens" INTEGER,
    "outputTokens" INTEGER,
    "costUsd" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Analysis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ChatMessage" (
    "id" TEXT NOT NULL,
    "reelId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "model" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ScrapeJob" (
    "id" TEXT NOT NULL,
    "competitorId" TEXT,
    "username" TEXT NOT NULL,
    "requestedCount" INTEGER NOT NULL,
    "actualCount" INTEGER NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL,
    "kind" TEXT NOT NULL DEFAULT 'initial',
    "apifyRunId" TEXT,
    "errorMessage" TEXT,
    "costUsd" DOUBLE PRECISION,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "ScrapeJob_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Conversation" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Conversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "AIMessage" (
    "id" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "model" TEXT,
    "inputTokens" INTEGER,
    "outputTokens" INTEGER,
    "costUsd" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AIMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "SocialConnection" (
    "id" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "accountName" TEXT NOT NULL,
    "accountPic" TEXT,
    "accessToken" TEXT NOT NULL,
    "refreshToken" TEXT,
    "expiresAt" TIMESTAMP(3),
    "scopes" TEXT NOT NULL DEFAULT '',
    "connectedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SocialConnection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "OAuthState" (
    "id" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "returnTo" TEXT NOT NULL DEFAULT '/',
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OAuthState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Task" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "dueDate" TIMESTAMP(3),
    "labelText" TEXT NOT NULL DEFAULT '',
    "labelColor" TEXT NOT NULL DEFAULT '',
    "columnId" TEXT NOT NULL DEFAULT 'por-hacer',
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Task_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ContentPiece" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "type" TEXT NOT NULL DEFAULT 'reel',
    "status" TEXT NOT NULL DEFAULT 'drafts',
    "color" TEXT NOT NULL DEFAULT '',
    "category" TEXT NOT NULL DEFAULT '',
    "date" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "format" TEXT NOT NULL DEFAULT '',
    "platform" TEXT NOT NULL DEFAULT '',
    "emoji" TEXT NOT NULL DEFAULT '',
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ContentPiece_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ContentTemplate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'reel',
    "status" TEXT NOT NULL DEFAULT 'drafts',
    "color" TEXT NOT NULL DEFAULT '',
    "category" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ContentTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ICPProfile" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL DEFAULT '',
    "edad" TEXT NOT NULL DEFAULT '',
    "ingresos" TEXT NOT NULL DEFAULT '',
    "nicho" TEXT NOT NULL DEFAULT '',
    "rol" TEXT NOT NULL DEFAULT '',
    "dolores" TEXT NOT NULL DEFAULT '[]',
    "deseos" TEXT NOT NULL DEFAULT '[]',
    "creencias" TEXT NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ICPProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "BusinessBase" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "content" TEXT NOT NULL DEFAULT '',
    "items" TEXT NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BusinessBase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Idea" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "format" TEXT NOT NULL DEFAULT '',
    "notes" TEXT NOT NULL DEFAULT '',
    "referenceUrl" TEXT NOT NULL DEFAULT '',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Idea_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "GuionTab" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'reel',
    "emoji" TEXT NOT NULL DEFAULT '',
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "GuionTab_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "GuionItem" (
    "id" TEXT NOT NULL,
    "tabId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL DEFAULT '',
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "GuionItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Competitor_username_key" ON "Competitor"("username");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Reel_instagramId_key" ON "Reel"("instagramId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Reel_competitorId_viewsCount_idx" ON "Reel"("competitorId", "viewsCount");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Reel_competitorId_commentsCount_idx" ON "Reel"("competitorId", "commentsCount");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Reel_competitorId_likesCount_idx" ON "Reel"("competitorId", "likesCount");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Reel_competitorId_postedAt_idx" ON "Reel"("competitorId", "postedAt");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Transcription_reelId_key" ON "Transcription"("reelId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Analysis_reelId_createdAt_idx" ON "Analysis"("reelId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ChatMessage_reelId_createdAt_idx" ON "ChatMessage"("reelId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ScrapeJob_status_startedAt_idx" ON "ScrapeJob"("status", "startedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Conversation_updatedAt_idx" ON "Conversation"("updatedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AIMessage_conversationId_createdAt_idx" ON "AIMessage"("conversationId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "SocialConnection_platform_idx" ON "SocialConnection"("platform");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "SocialConnection_platform_key" ON "SocialConnection"("platform");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "OAuthState_state_key" ON "OAuthState"("state");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "BusinessBase_key_key" ON "BusinessBase"("key");

-- AddForeignKey
ALTER TABLE "Reel" ADD CONSTRAINT "Reel_competitorId_fkey" FOREIGN KEY ("competitorId") REFERENCES "Competitor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transcription" ADD CONSTRAINT "Transcription_reelId_fkey" FOREIGN KEY ("reelId") REFERENCES "Reel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Analysis" ADD CONSTRAINT "Analysis_reelId_fkey" FOREIGN KEY ("reelId") REFERENCES "Reel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage_reelId_fkey" FOREIGN KEY ("reelId") REFERENCES "Reel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScrapeJob" ADD CONSTRAINT "ScrapeJob_competitorId_fkey" FOREIGN KEY ("competitorId") REFERENCES "Competitor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AIMessage" ADD CONSTRAINT "AIMessage_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GuionItem" ADD CONSTRAINT "GuionItem_tabId_fkey" FOREIGN KEY ("tabId") REFERENCES "GuionTab"("id") ON DELETE CASCADE ON UPDATE CASCADE;


-- ── Migración: 20260420200226_multi_tenant_schema ──
-- DropIndex
DROP INDEX "BusinessBase_key_key";

-- DropIndex
DROP INDEX "Competitor_username_key";

-- DropIndex
DROP INDEX "SocialConnection_platform_key";

-- AlterTable
ALTER TABLE "AIMessage" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Analysis" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "BusinessBase" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "ChatMessage" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Competitor" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "ContentPiece" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "ContentTemplate" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Conversation" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "GuionItem" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "GuionTab" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "ICPProfile" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Idea" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "OAuthState" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Reel" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "ScrapeJob" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "SocialConnection" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Task" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Transcription" ADD COLUMN IF NOT EXISTS "userId" TEXT NOT NULL DEFAULT '';

-- CreateTable
CREATE TABLE IF NOT EXISTS "Profile" (
    "id" TEXT NOT NULL,
    "email" TEXT,
    "displayName" TEXT,
    "avatarUrl" TEXT,
    "instagramUsername" TEXT,
    "nicho" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "UserReel" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "instagramId" TEXT NOT NULL,
    "shortcode" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "thumbnailUrl" TEXT,
    "videoUrl" TEXT,
    "caption" TEXT,
    "durationSec" DOUBLE PRECISION,
    "viewsCount" INTEGER NOT NULL DEFAULT 0,
    "viewsOrganic" INTEGER NOT NULL DEFAULT 0,
    "viewsPaid" INTEGER NOT NULL DEFAULT 0,
    "likesCount" INTEGER NOT NULL DEFAULT 0,
    "savesCount" INTEGER NOT NULL DEFAULT 0,
    "commentsCount" INTEGER NOT NULL DEFAULT 0,
    "sharesCount" INTEGER NOT NULL DEFAULT 0,
    "reachCount" INTEGER NOT NULL DEFAULT 0,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "organicPercent" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "multiplier" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "isAd" BOOLEAN NOT NULL DEFAULT false,
    "isTrialReel" BOOLEAN NOT NULL DEFAULT false,
    "publishedAt" TIMESTAMP(3),
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserReel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Story" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "instagramId" TEXT NOT NULL,
    "thumbnailUrl" TEXT,
    "reach" INTEGER NOT NULL DEFAULT 0,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "replies" INTEGER NOT NULL DEFAULT 0,
    "stickerTaps" INTEGER NOT NULL DEFAULT 0,
    "exits" INTEGER NOT NULL DEFAULT 0,
    "completionRate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "publishedAt" TIMESTAMP(3),
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Story_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "AccountSnapshot" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "followers" INTEGER NOT NULL DEFAULT 0,
    "following" INTEGER NOT NULL DEFAULT 0,
    "posts" INTEGER NOT NULL DEFAULT 0,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "reach" INTEGER NOT NULL DEFAULT 0,
    "profileVisits" INTEGER NOT NULL DEFAULT 0,
    "newFollowers" INTEGER NOT NULL DEFAULT 0,
    "engagementRate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AccountSnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "IncomeRecord" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "source" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "reelId" TEXT,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "IncomeRecord_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "UserReel_instagramId_key" ON "UserReel"("instagramId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "UserReel_userId_publishedAt_idx" ON "UserReel"("userId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "UserReel_userId_viewsCount_idx" ON "UserReel"("userId", "viewsCount");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Story_instagramId_key" ON "Story"("instagramId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Story_userId_publishedAt_idx" ON "Story"("userId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AccountSnapshot_userId_date_idx" ON "AccountSnapshot"("userId", "date");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AccountSnapshot_userId_date_key" ON "AccountSnapshot"("userId", "date");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IncomeRecord_userId_date_idx" ON "IncomeRecord"("userId", "date");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IncomeRecord_userId_source_idx" ON "IncomeRecord"("userId", "source");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AIMessage_userId_idx" ON "AIMessage"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Analysis_userId_idx" ON "Analysis"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "BusinessBase_userId_idx" ON "BusinessBase"("userId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "BusinessBase_userId_key_key" ON "BusinessBase"("userId", "key");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ChatMessage_userId_idx" ON "ChatMessage"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Competitor_userId_idx" ON "Competitor"("userId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Competitor_userId_username_key" ON "Competitor"("userId", "username");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentPiece_userId_idx" ON "ContentPiece"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentTemplate_userId_idx" ON "ContentTemplate"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Conversation_userId_idx" ON "Conversation"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "GuionItem_userId_idx" ON "GuionItem"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "GuionTab_userId_idx" ON "GuionTab"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ICPProfile_userId_idx" ON "ICPProfile"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Idea_userId_idx" ON "Idea"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "OAuthState_userId_idx" ON "OAuthState"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Reel_userId_idx" ON "Reel"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ScrapeJob_userId_idx" ON "ScrapeJob"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "SocialConnection_userId_idx" ON "SocialConnection"("userId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "SocialConnection_userId_platform_key" ON "SocialConnection"("userId", "platform");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Task_userId_idx" ON "Task"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Transcription_userId_idx" ON "Transcription"("userId");


-- Drop temporary DEFAULT '' on userId columns (kept only so ADD COLUMN works on tables with existing rows)
ALTER TABLE "AIMessage" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "Analysis" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "BusinessBase" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "ChatMessage" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "Competitor" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "ContentPiece" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "ContentTemplate" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "Conversation" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "GuionItem" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "GuionTab" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "ICPProfile" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "Idea" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "OAuthState" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "Reel" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "ScrapeJob" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "SocialConnection" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "Task" ALTER COLUMN "userId" DROP DEFAULT;
ALTER TABLE "Transcription" ALTER COLUMN "userId" DROP DEFAULT;


-- ── Migración: 20260421000000_client_workspaces ──
-- CreateEnum
CREATE TYPE "GlobalRole" AS ENUM ('PENDING', 'MEMBER', 'SUPER_ADMIN');

-- CreateEnum
CREATE TYPE "ClientRole" AS ENUM ('ACCESS');

-- DropIndex
DROP INDEX "AIMessage_userId_idx";

-- DropIndex
DROP INDEX "AccountSnapshot_userId_date_idx";

-- DropIndex
DROP INDEX "AccountSnapshot_userId_date_key";

-- DropIndex
DROP INDEX "Analysis_userId_idx";

-- DropIndex
DROP INDEX "BusinessBase_userId_idx";

-- DropIndex
DROP INDEX "BusinessBase_userId_key_key";

-- DropIndex
DROP INDEX "ChatMessage_userId_idx";

-- DropIndex
DROP INDEX "Competitor_userId_idx";

-- DropIndex
DROP INDEX "Competitor_userId_username_key";

-- DropIndex
DROP INDEX "ContentPiece_userId_idx";

-- DropIndex
DROP INDEX "ContentTemplate_userId_idx";

-- DropIndex
DROP INDEX "Conversation_userId_idx";

-- DropIndex
DROP INDEX "GuionItem_userId_idx";

-- DropIndex
DROP INDEX "GuionTab_userId_idx";

-- DropIndex
DROP INDEX "ICPProfile_userId_idx";

-- DropIndex
DROP INDEX "Idea_userId_idx";

-- DropIndex
DROP INDEX "IncomeRecord_userId_date_idx";

-- DropIndex
DROP INDEX "IncomeRecord_userId_source_idx";

-- DropIndex
DROP INDEX "Reel_userId_idx";

-- DropIndex
DROP INDEX "ScrapeJob_userId_idx";

-- DropIndex
DROP INDEX "SocialConnection_userId_idx";

-- DropIndex
DROP INDEX "SocialConnection_userId_platform_key";

-- DropIndex
DROP INDEX "Story_userId_publishedAt_idx";

-- DropIndex
DROP INDEX "Task_userId_idx";

-- DropIndex
DROP INDEX "Transcription_userId_idx";

-- DropIndex
DROP INDEX "UserReel_userId_publishedAt_idx";

-- DropIndex
DROP INDEX "UserReel_userId_viewsCount_idx";

-- AlterTable
ALTER TABLE "AIMessage" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "AccountSnapshot" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "Analysis" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "BusinessBase" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "ChatMessage" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "Competitor" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "ContentPiece" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "ContentTemplate" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "Conversation" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "GuionItem" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "GuionTab" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "ICPProfile" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "Idea" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "IncomeRecord" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "OAuthState" ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Profile" ADD COLUMN IF NOT EXISTS "globalRole" "GlobalRole" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "Reel" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "ScrapeJob" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "SocialConnection" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "Story" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "Task" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "Transcription" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- AlterTable
ALTER TABLE "UserReel" DROP COLUMN "userId",
ADD COLUMN IF NOT EXISTS "clientId" TEXT NOT NULL,
ADD COLUMN IF NOT EXISTS "createdBy" TEXT,
ADD COLUMN IF NOT EXISTS "updatedBy" TEXT;

-- CreateTable
CREATE TABLE IF NOT EXISTS "Client" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Client_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ClientAccess" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "roleInClient" "ClientRole" NOT NULL DEFAULT 'ACCESS',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ClientAccess_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Client_slug_key" ON "Client"("slug");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientAccess_userId_idx" ON "ClientAccess"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientAccess_clientId_idx" ON "ClientAccess"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ClientAccess_userId_clientId_key" ON "ClientAccess"("userId", "clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AIMessage_clientId_idx" ON "AIMessage"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AccountSnapshot_clientId_date_idx" ON "AccountSnapshot"("clientId", "date");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AccountSnapshot_clientId_date_key" ON "AccountSnapshot"("clientId", "date");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Analysis_clientId_idx" ON "Analysis"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "BusinessBase_clientId_idx" ON "BusinessBase"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "BusinessBase_clientId_key_key" ON "BusinessBase"("clientId", "key");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ChatMessage_clientId_idx" ON "ChatMessage"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Competitor_clientId_idx" ON "Competitor"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Competitor_clientId_username_key" ON "Competitor"("clientId", "username");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentPiece_clientId_idx" ON "ContentPiece"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentTemplate_clientId_idx" ON "ContentTemplate"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Conversation_clientId_idx" ON "Conversation"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "GuionItem_clientId_idx" ON "GuionItem"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "GuionTab_clientId_idx" ON "GuionTab"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ICPProfile_clientId_idx" ON "ICPProfile"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Idea_clientId_idx" ON "Idea"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IncomeRecord_clientId_date_idx" ON "IncomeRecord"("clientId", "date");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IncomeRecord_clientId_source_idx" ON "IncomeRecord"("clientId", "source");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "OAuthState_clientId_idx" ON "OAuthState"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Reel_clientId_idx" ON "Reel"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ScrapeJob_clientId_idx" ON "ScrapeJob"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "SocialConnection_clientId_idx" ON "SocialConnection"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "SocialConnection_clientId_platform_key" ON "SocialConnection"("clientId", "platform");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Story_clientId_publishedAt_idx" ON "Story"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Task_clientId_idx" ON "Task"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Transcription_clientId_idx" ON "Transcription"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "UserReel_clientId_publishedAt_idx" ON "UserReel"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "UserReel_clientId_viewsCount_idx" ON "UserReel"("clientId", "viewsCount");

-- AddForeignKey
ALTER TABLE "ClientAccess" ADD CONSTRAINT "ClientAccess_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Profile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientAccess" ADD CONSTRAINT "ClientAccess_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE CASCADE ON UPDATE CASCADE;



-- ── Migración: 20260422000000_youtube_video ──
-- CreateTable
CREATE TABLE IF NOT EXISTS "YouTubeVideo" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "videoId" TEXT NOT NULL,
    "channelId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "thumbnailUrl" TEXT,
    "url" TEXT NOT NULL,
    "durationSec" INTEGER NOT NULL DEFAULT 0,
    "durationLabel" TEXT NOT NULL DEFAULT '',
    "viewsCount" INTEGER NOT NULL DEFAULT 0,
    "likesCount" INTEGER NOT NULL DEFAULT 0,
    "commentsCount" INTEGER NOT NULL DEFAULT 0,
    "favoriteCount" INTEGER NOT NULL DEFAULT 0,
    "watchTimeMinutes" INTEGER,
    "averageViewDuration" INTEGER,
    "averageViewPercent" DOUBLE PRECISION,
    "ctr" DOUBLE PRECISION,
    "publishedAt" TIMESTAMP(3),
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "YouTubeVideo_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "YouTubeVideo_videoId_key" ON "YouTubeVideo"("videoId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "YouTubeVideo_clientId_publishedAt_idx" ON "YouTubeVideo"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "YouTubeVideo_clientId_viewsCount_idx" ON "YouTubeVideo"("clientId", "viewsCount");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "YouTubeVideo_channelId_idx" ON "YouTubeVideo"("channelId");


-- ── Migración: 20260423000000_add_chat_message_tokens ──
-- AlterTable: add token / cost columns to ChatMessage (parity with AIMessage)
ALTER TABLE "ChatMessage" ADD COLUMN IF NOT EXISTS "inputTokens" INTEGER;
ALTER TABLE "ChatMessage" ADD COLUMN IF NOT EXISTS "outputTokens" INTEGER;
ALTER TABLE "ChatMessage" ADD COLUMN IF NOT EXISTS "costUsd" DOUBLE PRECISION;


-- ── Migración: 20260424000000_account_snapshot_platform ──
-- MC-02: AccountSnapshot platform discriminator
-- Adds a `platform` column to distinguish between Instagram, YouTube, TikTok
-- snapshots that share (clientId, date). Without this, YT sync and IG sync
-- silently overwrote each other in the same row.
--
-- Safe to apply on live prod because prod has 0 rows at migration time
-- (verified via scripts/check-db.ts). Default 'instagram' is inocuo on empty
-- table and matches the historical intent (this table was originally added
-- for IG-only metrics).
--
-- Rollback SQL documented in Plan Definitivo v2.1 §10.

-- AlterTable
ALTER TABLE "AccountSnapshot" ADD COLUMN IF NOT EXISTS "platform" TEXT NOT NULL DEFAULT 'instagram';

-- DropIndex
DROP INDEX IF EXISTS "AccountSnapshot_clientId_date_key";
DROP INDEX IF EXISTS "AccountSnapshot_clientId_date_idx";

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AccountSnapshot_clientId_platform_date_key" ON "AccountSnapshot"("clientId", "platform", "date");
CREATE INDEX IF NOT EXISTS "AccountSnapshot_clientId_platform_date_idx" ON "AccountSnapshot"("clientId", "platform", "date");


-- ── Migración: 20260506180532_add_client_theme_key ──
-- AlterTable
ALTER TABLE "Client" ADD COLUMN IF NOT EXISTS "themeKey" TEXT NOT NULL DEFAULT 'eternity';


-- ── Migración: 20260506193556_add_transcript_history ──
-- CreateTable
CREATE TABLE IF NOT EXISTS "TranscriptHistory" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "url" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "title" TEXT,
    "creator" TEXT,
    "duration" TEXT,
    "thumbnail" TEXT,
    "transcript" TEXT,
    "summary" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TranscriptHistory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TranscriptHistory_clientId_createdAt_idx" ON "TranscriptHistory"("clientId", "createdAt");


-- ── Migración: 20260506195038_add_research_and_feed ──
-- CreateTable
CREATE TABLE IF NOT EXISTS "ContentResearchHistory" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "platform" TEXT NOT NULL,
    "channelUrl" TEXT NOT NULL,
    "channelName" TEXT,
    "channelAvatar" TEXT,
    "timeframeDays" INTEGER NOT NULL DEFAULT 30,
    "videos" JSONB NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ContentResearchHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "VideoFeedAccount" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "platform" TEXT NOT NULL,
    "channelUrl" TEXT NOT NULL,
    "channelName" TEXT,
    "channelAvatar" TEXT,
    "posts" JSONB NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "VideoFeedAccount_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentResearchHistory_clientId_createdAt_idx" ON "ContentResearchHistory"("clientId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "VideoFeedAccount_clientId_idx" ON "VideoFeedAccount"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "VideoFeedAccount_clientId_platform_key" ON "VideoFeedAccount"("clientId", "platform");


-- ── Migración: 20260514000000_user_role_refactor ──
-- Migration: user_role_refactor
-- Replaces GlobalRole (PENDING/MEMBER/SUPER_ADMIN) + ClientAccess M:N
-- with UserRole (ADMIN/TEAM/SETTER/CLIENT) + direct Profile.clientId FK.

-- 1. Create new enum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'TEAM', 'SETTER', 'CLIENT');

-- 2. Add new columns to Profile (nullable first for data migration)
ALTER TABLE "Profile"
  ADD COLUMN IF NOT EXISTS "role"     "UserRole" NOT NULL DEFAULT 'CLIENT',
  ADD COLUMN IF NOT EXISTS "clientId" TEXT;

-- 3. Data migration: map old roles to new
UPDATE "Profile" SET "role" = 'ADMIN'  WHERE "globalRole" = 'SUPER_ADMIN';
UPDATE "Profile" SET "role" = 'CLIENT' WHERE "globalRole" IN ('MEMBER', 'PENDING');

-- 4. Data migration: assign clientId from first ClientAccess for non-admin users
UPDATE "Profile" p
SET "clientId" = (
  SELECT ca."clientId"
  FROM "ClientAccess" ca
  WHERE ca."userId" = p."id"
  ORDER BY ca."createdAt" ASC
  LIMIT 1
)
WHERE p."role" != 'ADMIN' AND p."clientId" IS NULL;

-- 5. Data migration: assign clientId for ADMIN users (first client by createdAt)
UPDATE "Profile" p
SET "clientId" = (
  SELECT c."id"
  FROM "Client" c
  ORDER BY c."createdAt" ASC
  LIMIT 1
)
WHERE p."role" = 'ADMIN' AND p."clientId" IS NULL;

-- 6. Add FK constraint for clientId
ALTER TABLE "Profile"
  ADD CONSTRAINT "Profile_clientId_fkey"
    FOREIGN KEY ("clientId") REFERENCES "Client"("id")
    ON DELETE SET NULL ON UPDATE CASCADE;

-- 7. Drop ClientAccess table and ClientRole enum
DROP TABLE IF EXISTS "ClientAccess";
DROP TYPE IF EXISTS "ClientRole";

-- 8. Drop old globalRole column and GlobalRole enum
ALTER TABLE "Profile" DROP COLUMN "globalRole";
DROP TYPE IF EXISTS "GlobalRole";

-- 9. Indexes
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "Profile_clientId_idx" ON "Profile"("clientId");


-- ── Migración: 20260515000000_add_tiktok_video ──
-- CreateTable
CREATE TABLE IF NOT EXISTS "TikTokVideo" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "videoId" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "coverUrl" TEXT,
    "shareUrl" TEXT NOT NULL DEFAULT '',
    "durationSec" INTEGER NOT NULL DEFAULT 0,
    "viewCount" INTEGER NOT NULL DEFAULT 0,
    "likeCount" INTEGER NOT NULL DEFAULT 0,
    "commentCount" INTEGER NOT NULL DEFAULT 0,
    "shareCount" INTEGER NOT NULL DEFAULT 0,
    "publishedAt" TIMESTAMP(3),
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TikTokVideo_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "TikTokVideo_videoId_key" ON "TikTokVideo"("videoId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TikTokVideo_clientId_publishedAt_idx" ON "TikTokVideo"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TikTokVideo_clientId_viewCount_idx" ON "TikTokVideo"("clientId", "viewCount");


-- ── Migración: 20260516000000_add_ad_account_campaign ──
-- CreateTable: AdAccount
CREATE TABLE IF NOT EXISTS "AdAccount" (
    "id"          TEXT NOT NULL,
    "clientId"    TEXT NOT NULL,
    "createdBy"   TEXT,
    "updatedBy"   TEXT,
    "platform"    TEXT NOT NULL,
    "accountId"   TEXT NOT NULL,
    "accountName" TEXT NOT NULL DEFAULT '',
    "currency"    TEXT NOT NULL DEFAULT 'USD',
    "syncedAt"    TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt"   TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt"   TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable: AdCampaign
CREATE TABLE IF NOT EXISTS "AdCampaign" (
    "id"           TEXT NOT NULL,
    "clientId"     TEXT NOT NULL,
    "adAccountId"  TEXT NOT NULL,
    "platform"     TEXT NOT NULL,
    "campaignId"   TEXT NOT NULL,
    "name"         TEXT NOT NULL DEFAULT '',
    "status"       TEXT NOT NULL DEFAULT 'UNKNOWN',
    "objective"    TEXT NOT NULL DEFAULT '',
    "spend"        DOUBLE PRECISION NOT NULL DEFAULT 0,
    "impressions"  INTEGER NOT NULL DEFAULT 0,
    "clicks"       INTEGER NOT NULL DEFAULT 0,
    "reach"        INTEGER NOT NULL DEFAULT 0,
    "ctr"          DOUBLE PRECISION NOT NULL DEFAULT 0,
    "cpc"          DOUBLE PRECISION NOT NULL DEFAULT 0,
    "roas"         DOUBLE PRECISION NOT NULL DEFAULT 0,
    "conversions"  INTEGER NOT NULL DEFAULT 0,
    "datePreset"   TEXT NOT NULL DEFAULT 'last_30d',
    "syncedAt"     TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt"    TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt"    TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdCampaign_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AdAccount_clientId_platform_accountId_key" ON "AdAccount"("clientId", "platform", "accountId");
CREATE INDEX IF NOT EXISTS "AdAccount_clientId_platform_idx" ON "AdAccount"("clientId", "platform");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AdCampaign_campaignId_key" ON "AdCampaign"("campaignId");
CREATE INDEX IF NOT EXISTS "AdCampaign_clientId_platform_idx" ON "AdCampaign"("clientId", "platform");
CREATE INDEX IF NOT EXISTS "AdCampaign_adAccountId_idx" ON "AdCampaign"("adAccountId");
CREATE INDEX IF NOT EXISTS "AdCampaign_clientId_spend_idx" ON "AdCampaign"("clientId", "spend");

-- AddForeignKey
ALTER TABLE "AdCampaign" ADD CONSTRAINT "AdCampaign_adAccountId_fkey"
    FOREIGN KEY ("adAccountId") REFERENCES "AdAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;


-- ── Migración: 20260519000000_add_profile_theme_key ──
-- Add themeKey to Profile so each user has their own brand theme preference.
-- Defaults to 'eternity' for all existing rows.
ALTER TABLE "Profile" ADD COLUMN IF NOT EXISTS "themeKey" TEXT NOT NULL DEFAULT 'eternity';


-- ── Migración: 20260519100000_indexes_ondelete_updatedat ──
-- Add updatedAt to GuionTab (safe: NOT NULL with DEFAULT fills existing rows)
ALTER TABLE "GuionTab" ADD COLUMN IF NOT EXISTS "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Add missing indexes
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "GuionItem_tabId_idx" ON "GuionItem"("tabId");
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "Task_clientId_columnId_idx" ON "Task"("clientId", "columnId");
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "IncomeRecord_reelId_idx" ON "IncomeRecord"("reelId");
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "ScrapeJob_competitorId_idx" ON "ScrapeJob"("competitorId");

-- Fix ScrapeJob → Competitor FK: ensure CASCADE delete (jobs are derivative of competitors)
ALTER TABLE "ScrapeJob" DROP CONSTRAINT IF EXISTS "ScrapeJob_competitorId_fkey";
ALTER TABLE "ScrapeJob" ADD CONSTRAINT "ScrapeJob_competitorId_fkey"
  FOREIGN KEY ("competitorId") REFERENCES "Competitor"("id")
  ON DELETE CASCADE ON UPDATE CASCADE;


-- ── Migración: 20260527000000_add_audience_snapshot ──
-- CreateTable (idempotent)
CREATE TABLE IF NOT EXISTS "AudienceSnapshot" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "platform" TEXT NOT NULL DEFAULT 'instagram',
    "date" TIMESTAMP(3) NOT NULL,
    "genderAge" JSONB NOT NULL DEFAULT '{}',
    "country" JSONB NOT NULL DEFAULT '{}',
    "city" JSONB NOT NULL DEFAULT '{}',
    "followerHistory" JSONB NOT NULL DEFAULT '[]',
    "reachHistory" JSONB NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,

    CONSTRAINT "AudienceSnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateIndex (idempotent)
CREATE UNIQUE INDEX IF NOT EXISTS IF NOT EXISTS "AudienceSnapshot_clientId_platform_date_key" ON "AudienceSnapshot"("clientId", "platform", "date");

-- CreateIndex (idempotent)
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "AudienceSnapshot_clientId_platform_date_idx" ON "AudienceSnapshot"("clientId", "platform", "date");


-- ── Migración: 20260528000000_add_instagram_comment ──
-- CreateTable (idempotent)
CREATE TABLE IF NOT EXISTS "InstagramComment" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "mediaId" TEXT NOT NULL,
    "commentId" TEXT NOT NULL,
    "username" TEXT NOT NULL DEFAULT '',
    "text" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "likeCount" INTEGER NOT NULL DEFAULT 0,
    "hidden" BOOLEAN NOT NULL DEFAULT false,
    "parentId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InstagramComment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS IF NOT EXISTS "InstagramComment_clientId_commentId_key" ON "InstagramComment"("clientId", "commentId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "InstagramComment_clientId_mediaId_idx" ON "InstagramComment"("clientId", "mediaId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "InstagramComment_clientId_parentId_idx" ON "InstagramComment"("clientId", "parentId");


-- ── Migración: 20260529000000_add_published_post ──
-- CreateTable (idempotent)
CREATE TABLE IF NOT EXISTS "PublishedPost" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "containerId" TEXT NOT NULL DEFAULT '',
    "postId" TEXT NOT NULL DEFAULT '',
    "mediaType" TEXT NOT NULL DEFAULT 'IMAGE',
    "mediaUrl" TEXT NOT NULL,
    "caption" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "errorMessage" TEXT NOT NULL DEFAULT '',
    "publishedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PublishedPost_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "PublishedPost_clientId_createdAt_idx" ON "PublishedPost"("clientId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "PublishedPost_clientId_status_idx" ON "PublishedPost"("clientId", "status");


-- ── Migración: 20260530000000_add_ig_messages ──
-- CreateTable: IGConversation
CREATE TABLE IF NOT EXISTS "IGConversation" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "participantId" TEXT NOT NULL DEFAULT '',
    "participantUsername" TEXT NOT NULL DEFAULT '',
    "participantPic" TEXT NOT NULL DEFAULT '',
    "lastMessageAt" TIMESTAMP(3),
    "lastUserMessageAt" TIMESTAMP(3),
    "unreadCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "IGConversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable: IGMessage
CREATE TABLE IF NOT EXISTS "IGMessage" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "messageId" TEXT NOT NULL,
    "fromId" TEXT NOT NULL DEFAULT '',
    "fromUsername" TEXT NOT NULL DEFAULT '',
    "text" TEXT NOT NULL DEFAULT '',
    "isFromBusiness" BOOLEAN NOT NULL DEFAULT false,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "IGMessage_pkey" PRIMARY KEY ("id")
);

-- Unique indexes
CREATE UNIQUE INDEX IF NOT EXISTS IF NOT EXISTS "IGConversation_clientId_conversationId_key" ON "IGConversation"("clientId", "conversationId");
CREATE UNIQUE INDEX IF NOT EXISTS IF NOT EXISTS "IGMessage_clientId_messageId_key" ON "IGMessage"("clientId", "messageId");

-- Regular indexes
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "IGConversation_clientId_lastMessageAt_idx" ON "IGConversation"("clientId", "lastMessageAt");
CREATE INDEX IF NOT EXISTS IF NOT EXISTS "IGMessage_clientId_conversationId_timestamp_idx" ON "IGMessage"("clientId", "conversationId", "timestamp");


-- ── Migración: 20260531000000_rename_impressions_to_totalviews ──
-- Rename AccountSnapshot.impressions → totalViews (idempotent)
-- Uses a DO block so re-running after manual application is a no-op.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'AccountSnapshot' AND column_name = 'impressions'
  ) THEN
    ALTER TABLE "AccountSnapshot" RENAME COLUMN "impressions" TO "totalViews";
  END IF;
END $$;


-- ── Migración: 20260601000000_fix_video_clientid_uniqueness ──
-- TikTokVideo: The table exists with old schema (tiktokId + old column names).
-- Both tables are empty (0 rows) so we can safely recreate TikTokVideo with correct schema.
-- This migration:
--   1. Drops old TikTokVideo and recreates it matching schema.prisma exactly
--   2. Fixes YouTubeVideo: replaces global videoId unique with (clientId, videoId) composite

-- ─── TikTokVideo: recreate with correct column names (was: tiktokId, viewsCount, etc.) ───
DROP TABLE IF EXISTS "TikTokVideo";

CREATE TABLE IF NOT EXISTS "TikTokVideo" (
    "id"           TEXT NOT NULL,
    "clientId"     TEXT NOT NULL,
    "createdBy"    TEXT,
    "updatedBy"    TEXT,
    "videoId"      TEXT NOT NULL,
    "title"        TEXT NOT NULL DEFAULT '',
    "description"  TEXT NOT NULL DEFAULT '',
    "coverUrl"     TEXT,
    "shareUrl"     TEXT NOT NULL DEFAULT '',
    "durationSec"  INTEGER NOT NULL DEFAULT 0,
    "viewCount"    INTEGER NOT NULL DEFAULT 0,
    "likeCount"    INTEGER NOT NULL DEFAULT 0,
    "commentCount" INTEGER NOT NULL DEFAULT 0,
    "shareCount"   INTEGER NOT NULL DEFAULT 0,
    "publishedAt"  TIMESTAMP(3),
    "syncedAt"     TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt"    TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt"    TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TikTokVideo_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "TikTokVideo_clientId_videoId_key"     ON "TikTokVideo"("clientId", "videoId");
CREATE INDEX IF NOT EXISTS        "TikTokVideo_clientId_publishedAt_idx" ON "TikTokVideo"("clientId", "publishedAt");
CREATE INDEX IF NOT EXISTS        "TikTokVideo_clientId_viewCount_idx"   ON "TikTokVideo"("clientId", "viewCount");

-- ─── YouTubeVideo: replace global unique with per-tenant composite unique ───
DROP INDEX IF EXISTS "YouTubeVideo_videoId_key";
CREATE UNIQUE INDEX IF NOT EXISTS "YouTubeVideo_clientId_videoId_key" ON "YouTubeVideo"("clientId", "videoId");


-- ── Migración: 20260601120000_add_igmessage_conversation_fk ──
-- IGMessage.conversationId → IGConversation.conversationId (CASCADE).
-- Self-sufficient + idempotent: ensures the referenced column is UNIQUE first
-- (some environments created IGConversation before the @unique was added), then
-- adds the FK only if it doesn't already exist.

-- 1) Required unique constraint on the referenced column
CREATE UNIQUE INDEX IF NOT EXISTS IF NOT EXISTS "IGConversation_conversationId_key"
  ON "IGConversation"("conversationId");

-- 2) Drop any orphan messages that would violate the FK (none expected)
DELETE FROM "IGMessage" m
  WHERE NOT EXISTS (SELECT 1 FROM "IGConversation" c WHERE c."conversationId" = m."conversationId");

-- 3) Add the FK only if it isn't already present
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'IGMessage_conversationId_fkey'
  ) THEN
    ALTER TABLE "IGMessage"
      ADD CONSTRAINT "IGMessage_conversationId_fkey"
      FOREIGN KEY ("conversationId") REFERENCES "IGConversation"("conversationId")
      ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;


-- ── Migración: 20260601130000_add_published_post_permalink ──
-- AlterTable
ALTER TABLE "PublishedPost" ADD COLUMN IF NOT EXISTS "permalink" TEXT;


-- ── Migración: 20260602000000_publish_carousel ──
-- Carousel support for Instagram publishing.
-- Additive, low-risk: two text[] columns defaulting to empty array.
ALTER TABLE "PublishedPost" ADD COLUMN IF NOT EXISTS "mediaUrls" TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE "PublishedPost" ADD COLUMN IF NOT EXISTS "itemTypes" TEXT[] NOT NULL DEFAULT '{}';

-- Backfill existing single-media rows so mediaUrls is never empty for old posts.
UPDATE "PublishedPost" SET "mediaUrls" = ARRAY["mediaUrl"] WHERE array_length("mediaUrls", 1) IS NULL AND "mediaUrl" <> '';


-- ============================================================
-- Bootstrap: Client workspace por defecto para GovBidder
-- ============================================================
-- Inserta un workspace "govbidder" si no existe ninguno.
-- El clientId de este workspace es el que usan los usuarios
-- del Content Dashboard integrado en GovBidder.
INSERT INTO "Client" ("id", "name", "slug", "themeKey", "createdAt", "updatedAt")
VALUES ('govbidder-main', 'GovBidder', 'govbidder', 'eternity', NOW(), NOW())
ON CONFLICT ("slug") DO NOTHING;

-- Notificamos a PostgREST para que recargue el schema
NOTIFY pgrst, 'reload schema';
