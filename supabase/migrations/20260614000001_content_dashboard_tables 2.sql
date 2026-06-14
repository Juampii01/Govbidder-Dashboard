-- ============================================================
-- Content Dashboard tables — schema completo
-- Generado desde prisma/schema.prisma (estado final, sin migraciones intermedias)
-- Idempotente: usa IF NOT EXISTS donde aplica
-- ============================================================

-- Crear el enum solo si no existe
DO $$ BEGIN
  CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'TEAM', 'SETTER', 'CLIENT');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";


-- CreateTable
CREATE TABLE IF NOT EXISTS "Profile" (
    "id" TEXT NOT NULL,
    "email" TEXT,
    "displayName" TEXT,
    "avatarUrl" TEXT,
    "instagramUsername" TEXT,
    "nicho" TEXT,
    "role" "UserRole" NOT NULL DEFAULT 'CLIENT',
    "themeKey" TEXT NOT NULL DEFAULT 'eternity',
    "clientId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Client" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "themeKey" TEXT NOT NULL DEFAULT 'eternity',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Client_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "Competitor" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "reelId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "model" TEXT,
    "inputTokens" INTEGER,
    "outputTokens" INTEGER,
    "costUsd" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ScrapeJob" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "title" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Conversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "AIMessage" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'reel',
    "emoji" TEXT NOT NULL DEFAULT '',
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "GuionTab_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "GuionItem" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "tabId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL DEFAULT '',
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "GuionItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "UserReel" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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

-- CreateTable
CREATE TABLE IF NOT EXISTS "AccountSnapshot" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "platform" TEXT NOT NULL DEFAULT 'instagram',
    "date" TIMESTAMP(3) NOT NULL,
    "followers" INTEGER NOT NULL DEFAULT 0,
    "following" INTEGER NOT NULL DEFAULT 0,
    "posts" INTEGER NOT NULL DEFAULT 0,
    "totalViews" INTEGER NOT NULL DEFAULT 0,
    "reach" INTEGER NOT NULL DEFAULT 0,
    "profileVisits" INTEGER NOT NULL DEFAULT 0,
    "newFollowers" INTEGER NOT NULL DEFAULT 0,
    "engagementRate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AccountSnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
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

-- CreateTable
CREATE TABLE IF NOT EXISTS "AdAccount" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
    "platform" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "accountName" TEXT NOT NULL DEFAULT '',
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "AdCampaign" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "adAccountId" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL DEFAULT 'UNKNOWN',
    "objective" TEXT NOT NULL DEFAULT '',
    "spend" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "clicks" INTEGER NOT NULL DEFAULT 0,
    "reach" INTEGER NOT NULL DEFAULT 0,
    "ctr" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "cpc" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "roas" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "conversions" INTEGER NOT NULL DEFAULT 0,
    "datePreset" TEXT NOT NULL DEFAULT 'last_30d',
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdCampaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "IncomeRecord" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "updatedBy" TEXT,
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

-- CreateTable
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

-- CreateTable
CREATE TABLE IF NOT EXISTS "PublishedPost" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "createdBy" TEXT,
    "containerId" TEXT NOT NULL DEFAULT '',
    "postId" TEXT NOT NULL DEFAULT '',
    "mediaType" TEXT NOT NULL DEFAULT 'IMAGE',
    "mediaUrl" TEXT NOT NULL,
    "mediaUrls" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "itemTypes" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "caption" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "errorMessage" TEXT NOT NULL DEFAULT '',
    "permalink" TEXT,
    "publishedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PublishedPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
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

-- CreateTable
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

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Client_slug_key" ON "Client"("slug");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Competitor_clientId_idx" ON "Competitor"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Competitor_clientId_username_key" ON "Competitor"("clientId", "username");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Reel_instagramId_key" ON "Reel"("instagramId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Reel_clientId_idx" ON "Reel"("clientId");

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
CREATE INDEX IF NOT EXISTS "Transcription_clientId_idx" ON "Transcription"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Analysis_clientId_idx" ON "Analysis"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Analysis_reelId_createdAt_idx" ON "Analysis"("reelId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ChatMessage_clientId_idx" ON "ChatMessage"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ChatMessage_reelId_createdAt_idx" ON "ChatMessage"("reelId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ScrapeJob_clientId_idx" ON "ScrapeJob"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ScrapeJob_status_startedAt_idx" ON "ScrapeJob"("status", "startedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ScrapeJob_competitorId_idx" ON "ScrapeJob"("competitorId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Conversation_clientId_idx" ON "Conversation"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Conversation_updatedAt_idx" ON "Conversation"("updatedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AIMessage_clientId_idx" ON "AIMessage"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AIMessage_conversationId_createdAt_idx" ON "AIMessage"("conversationId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "SocialConnection_clientId_idx" ON "SocialConnection"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "SocialConnection_platform_idx" ON "SocialConnection"("platform");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "SocialConnection_clientId_platform_key" ON "SocialConnection"("clientId", "platform");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "OAuthState_state_key" ON "OAuthState"("state");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "OAuthState_clientId_idx" ON "OAuthState"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "OAuthState_userId_idx" ON "OAuthState"("userId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Task_clientId_idx" ON "Task"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Task_clientId_columnId_idx" ON "Task"("clientId", "columnId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentPiece_clientId_idx" ON "ContentPiece"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentTemplate_clientId_idx" ON "ContentTemplate"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ICPProfile_clientId_idx" ON "ICPProfile"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "BusinessBase_clientId_idx" ON "BusinessBase"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "BusinessBase_clientId_key_key" ON "BusinessBase"("clientId", "key");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Idea_clientId_idx" ON "Idea"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "GuionTab_clientId_idx" ON "GuionTab"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "GuionItem_clientId_idx" ON "GuionItem"("clientId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "GuionItem_tabId_idx" ON "GuionItem"("tabId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "UserReel_instagramId_key" ON "UserReel"("instagramId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "UserReel_clientId_publishedAt_idx" ON "UserReel"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "UserReel_clientId_viewsCount_idx" ON "UserReel"("clientId", "viewsCount");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Story_instagramId_key" ON "Story"("instagramId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "Story_clientId_publishedAt_idx" ON "Story"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "YouTubeVideo_clientId_publishedAt_idx" ON "YouTubeVideo"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "YouTubeVideo_clientId_viewsCount_idx" ON "YouTubeVideo"("clientId", "viewsCount");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "YouTubeVideo_channelId_idx" ON "YouTubeVideo"("channelId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "YouTubeVideo_clientId_videoId_key" ON "YouTubeVideo"("clientId", "videoId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TikTokVideo_clientId_publishedAt_idx" ON "TikTokVideo"("clientId", "publishedAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TikTokVideo_clientId_viewCount_idx" ON "TikTokVideo"("clientId", "viewCount");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "TikTokVideo_clientId_videoId_key" ON "TikTokVideo"("clientId", "videoId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AccountSnapshot_clientId_platform_date_idx" ON "AccountSnapshot"("clientId", "platform", "date");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AccountSnapshot_clientId_platform_date_key" ON "AccountSnapshot"("clientId", "platform", "date");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AudienceSnapshot_clientId_platform_date_idx" ON "AudienceSnapshot"("clientId", "platform", "date");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AudienceSnapshot_clientId_platform_date_key" ON "AudienceSnapshot"("clientId", "platform", "date");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ContentResearchHistory_clientId_createdAt_idx" ON "ContentResearchHistory"("clientId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "VideoFeedAccount_clientId_idx" ON "VideoFeedAccount"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "VideoFeedAccount_clientId_platform_key" ON "VideoFeedAccount"("clientId", "platform");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TranscriptHistory_clientId_createdAt_idx" ON "TranscriptHistory"("clientId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AdAccount_clientId_platform_idx" ON "AdAccount"("clientId", "platform");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AdAccount_clientId_platform_accountId_key" ON "AdAccount"("clientId", "platform", "accountId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AdCampaign_campaignId_key" ON "AdCampaign"("campaignId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AdCampaign_clientId_platform_idx" ON "AdCampaign"("clientId", "platform");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AdCampaign_adAccountId_idx" ON "AdCampaign"("adAccountId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AdCampaign_clientId_spend_idx" ON "AdCampaign"("clientId", "spend");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IncomeRecord_clientId_date_idx" ON "IncomeRecord"("clientId", "date");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IncomeRecord_clientId_source_idx" ON "IncomeRecord"("clientId", "source");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IncomeRecord_reelId_idx" ON "IncomeRecord"("reelId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "InstagramComment_clientId_mediaId_idx" ON "InstagramComment"("clientId", "mediaId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "InstagramComment_clientId_parentId_idx" ON "InstagramComment"("clientId", "parentId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "InstagramComment_clientId_commentId_key" ON "InstagramComment"("clientId", "commentId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "PublishedPost_clientId_createdAt_idx" ON "PublishedPost"("clientId", "createdAt");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "PublishedPost_clientId_status_idx" ON "PublishedPost"("clientId", "status");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "IGConversation_conversationId_key" ON "IGConversation"("conversationId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IGConversation_clientId_lastMessageAt_idx" ON "IGConversation"("clientId", "lastMessageAt");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "IGConversation_clientId_conversationId_key" ON "IGConversation"("clientId", "conversationId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "IGMessage_clientId_conversationId_timestamp_idx" ON "IGMessage"("clientId", "conversationId", "timestamp");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "IGMessage_clientId_messageId_key" ON "IGMessage"("clientId", "messageId");

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reel" ADD CONSTRAINT "Reel_competitorId_fkey" FOREIGN KEY ("competitorId") REFERENCES "Competitor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transcription" ADD CONSTRAINT "Transcription_reelId_fkey" FOREIGN KEY ("reelId") REFERENCES "Reel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Analysis" ADD CONSTRAINT "Analysis_reelId_fkey" FOREIGN KEY ("reelId") REFERENCES "Reel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage_reelId_fkey" FOREIGN KEY ("reelId") REFERENCES "Reel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScrapeJob" ADD CONSTRAINT "ScrapeJob_competitorId_fkey" FOREIGN KEY ("competitorId") REFERENCES "Competitor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AIMessage" ADD CONSTRAINT "AIMessage_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GuionItem" ADD CONSTRAINT "GuionItem_tabId_fkey" FOREIGN KEY ("tabId") REFERENCES "GuionTab"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdCampaign" ADD CONSTRAINT "AdCampaign_adAccountId_fkey" FOREIGN KEY ("adAccountId") REFERENCES "AdAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IGMessage" ADD CONSTRAINT "IGMessage_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "IGConversation"("conversationId") ON DELETE CASCADE ON UPDATE CASCADE;


-- ============================================================
-- Bootstrap: workspace GovBidder por defecto
-- ============================================================
INSERT INTO "Client" ("id", "name", "slug", "themeKey", "createdAt", "updatedAt")
VALUES ('govbidder-main', 'GovBidder', 'govbidder', 'eternity', NOW(), NOW())
ON CONFLICT ("slug") DO NOTHING;

-- Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';
