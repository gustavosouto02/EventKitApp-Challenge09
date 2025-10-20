//
//  EventKitAppWidgetExtensionLiveActivity.swift
//  EventKitAppWidgetExtension
//
//  Created by Thiago de Jesus on 19/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct EventKitAppWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NotificationsAttributes.self) { context in
            notificationView(for: context)
                .activityBackgroundTint(Color.red)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.date, style: .timer)
                        .padding(20)
                        .padding(.leading, 30)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.attributes.title)
                }
                DynamicIslandExpandedRegion(.trailing) {
                }

            } compactLeading: {
                
            } compactTrailing: {
                
            } minimal: {
            }

        }

    }
    
     func notificationView(for context: ActivityViewContext<NotificationsAttributes>) -> some View {
         NotificationView(title: context.attributes.title, description: context.attributes.description, date: context.state.date)
    }
}


