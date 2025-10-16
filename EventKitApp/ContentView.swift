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
    @State private var isShowingEditSheet: Bool = false

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }()

    var body: some View {
        NavigationView {

            List(reminderManager.reminders, id: \.calendarItemIdentifier) {
                reminder in
                VStack(alignment: .leading) {
                    Text(reminder.title)
                        .font(.headline)

                    if let notes = reminder.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }

                    if let comps = reminder.dueDateComponents,
                        let date = Calendar.current.date(from: comps)
                    {
                        Text(dateFormatter.string(from: date))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        reminderManager.deleteReminder(reminder)
                    } label: {
                        Label("Deletar", systemImage: "trash")
                    }

                    Button {
                        editReminder = reminder
                        isShowingEditSheet = true
                    } label: {
                        Label("Editar", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }

            .navigationTitle("Lembretes com Data")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
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
