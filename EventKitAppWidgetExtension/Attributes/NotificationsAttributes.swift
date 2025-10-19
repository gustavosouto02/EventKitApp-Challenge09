//
//  NotificationsAttributes.swift
//  ActivitiesStudys
//
//  Created by Thiago de Jesus on 16/10/25.
//

import Foundation
import ActivityKit

struct NotificationsAttributes: ActivityAttributes {
    
    public struct ContentState: Hashable, Codable {
        var date: Date
    }
    var title: String
    var description: String
}

extension NotificationsAttributes {
     static var preview: NotificationsAttributes {
         NotificationsAttributes(title: "Title", description: "Description")
    }
}

extension NotificationsAttributes.ContentState {
     static var date: NotificationsAttributes.ContentState {
        NotificationsAttributes.ContentState(date: Date())
     }
}
