//
//  ContentView.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 16/10/25.
//

import EventKit
import SwiftUI
import TipKit

struct ContentView: View {
    @StateObject private var reminderManager = ReminderManager()
    @ObservedObject private var notificationManager: NotificationsManager
    @State private var showAddReminderSheet = false
    @State private var editReminder: EKReminder?
    
    var newReminderTip = NewReminderTip()
    
    init(notificationManager: NotificationsManager) {
        self.notificationManager = notificationManager
    }

    var body: some View {
        NavigationView {
            VStack {
                if reminderManager.reminders.isEmpty {
                    EmptyStateView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(y: -80)
                } else {
                    ReminderListView(
                        reminderManager: reminderManager,
                        reminders: reminderManager.reminders,
                        editReminder: $editReminder
                    )
                }

            }
            .navigationTitle("Lembretes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        editReminder = nil
                        showAddReminderSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popoverTip(newReminderTip, arrowEdge: .top)
                }
            }
            .task {
                do{
                    try Tips.configure()
                }catch{
                    print("Erro de inicializacao do TipKit \(error.localizedDescription)")
                }
            }
            .sheet(isPresented: $showAddReminderSheet) {
                AddReminderView(reminderManager: reminderManager, notificationManager: notificationManager)
            }
            .sheet(item: $editReminder) { reminder in
                AddReminderView(
                    reminderManager: reminderManager, notificationManager: notificationManager,
                    editReminder: reminder
                )
            }
        }
    }
}

extension EKReminder: @retroactive Identifiable {
    public var id: String {
        self.calendarItemIdentifier
    }
}
