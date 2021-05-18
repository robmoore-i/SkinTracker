//
// Created by Rob on 15/5/21.
// The AppCenter dashboard is here: https://appcenter.ms/users/robmoore121/apps/SkinTracker/analytics/overview
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

struct UsageAnalytics {
    private static var analytics: [UsageAnalyticsProvider] = []

    static func setup() {
        analytics.append(AppCenterUsageAnalytics())
    }

    static func event(_ event: TrackedEvent, properties: [String: String]? = nil) {
        analytics.forEach { provider in
            provider.event(event, properties: properties)
        }
    }
}

private protocol UsageAnalyticsProvider {
    func event(_ event: TrackedEvent, properties: [String: String]?)
}

private class AppCenterUsageAnalytics: UsageAnalyticsProvider {
    init() {
        AppCenter.start(withAppSecret: "8edb0034-b2ca-4ffb-b8db-3278744e9f7a", services: [Analytics.self, Crashes.self])
    }

    func event(_ event: TrackedEvent, properties: [String: String]?) {
        var propertiesCopy = properties ?? [:]
        propertiesCopy["deviceIdForVendor"] = IdentifiedDevice.deviceIdForVendor()
        Analytics.trackEvent(event.rawValue, withProperties: propertiesCopy)
    }
}