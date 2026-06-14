import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { VideoFeedView } from "@/components/marketing/video-feed/VideoFeedView"
export const metadata = { title: "Video Feed" }
export default function VideoFeedPage() {
  return <DashboardLayout><VideoFeedView /></DashboardLayout>
}
