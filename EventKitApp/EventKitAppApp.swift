//
//  EventKitAppApp.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 16/10/25.
//

import SwiftUI

@main
struct EventKitAppApp: App {
    @UIApplicationDelegateAdaptor(EventKitAppDelegate.self) var eventKitAppDelegate
    let notificationManager = NotificationsManager()
    var body: some Scene {
        WindowGroup {
            ContentView(notificationManager: notificationManager)
        }
    }
}
