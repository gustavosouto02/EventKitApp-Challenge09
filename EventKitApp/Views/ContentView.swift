//
//  ContentView.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 16/10/25.
//

import EventKit
import SwiftUI

struct ContentView: View {
    @StateObject private var reminderManager = ReminderManager()
    @State private var showAddReminderSheet = false
    @State private var editReminder: EKReminder?

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
                }
            }
            .sheet(isPresented: $showAddReminderSheet) {
                AddReminderView(reminderManager: reminderManager)
            }
            .sheet(item: $editReminder) { reminder in
                AddReminderView(
                    reminderManager: reminderManager,
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
