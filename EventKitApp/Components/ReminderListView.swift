//
//  ReminderListView.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 17/10/25.
//

import SwiftUI
import EventKit

struct ReminderListView: View {
    @ObservedObject var reminderManager: ReminderManager
    let reminders: [EKReminder]
    @Binding var editReminder: EKReminder?

    var body: some View {
        List(reminders) { reminder in 
            ReminderRowView(reminderManager: reminderManager, reminder: reminder)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        reminderManager.deleteReminder(reminder)
                    } label: {
                        Label("Deletar", systemImage: "trash")
                    }

                    Button {
                        editReminder = reminder
                    } label: {
                        Label("Editar", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
                .onTapGesture {
                    editReminder = reminder
                }
        }
    }
}
