import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { AdsProPage } from "@/components/marketing/ads/AdsProPage"
export const metadata = { title: "Ads" }
export default function AdsPage() {
  return <DashboardLayout><AdsProPage /></DashboardLayout>
}
