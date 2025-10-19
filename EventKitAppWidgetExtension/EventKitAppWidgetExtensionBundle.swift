//
//  EventKitAppWidgetExtensionBundle.swift
//  EventKitAppWidgetExtension
//
//  Created by Thiago de Jesus on 19/10/25.
//

import WidgetKit
import SwiftUI

@main
struct EventKitAppWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        EventKitAppWidgetExtension()
        EventKitAppWidgetExtensionControl()
        EventKitAppWidgetExtensionLiveActivity()
    }
}
