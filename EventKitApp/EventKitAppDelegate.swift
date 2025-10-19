//
//  NotificationDelegate.swift
//  ActivitiesStudys
//
//  Created by Thiago de Jesus on 19/10/25.
//

import Foundation
import UIKit

class EventKitAppDelegate: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
                if userInfo["action"] as? String == "startLiveActivity" {
                    let title = userInfo["title"] as? String ?? "Titulo"
                    let description = userInfo["description"] as? String ?? "Descrição"
                    let model = NotificationFormModel(title: title, description: description, date: Date())
                
                    LiveActivitieManager.shared.startLiveActivity(model: model)
                    print("startou")
                }
                completionHandler()
    }
}
