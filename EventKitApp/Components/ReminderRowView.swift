//
//  ReminderRowView.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 17/10/25.
//

import SwiftUI
import EventKit

struct ReminderRowView: View {
    @ObservedObject var reminderManager: ReminderManager
    let reminder: EKReminder

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                reminderManager.toggleCompletion(for: reminder)
            } label: {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(reminder.isCompleted ? .accentColor : .secondary)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                    .strikethrough(reminder.isCompleted, color: .primary)

                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if let comps = reminder.dueDateComponents,
                   let date = Calendar.current.date(from: comps) {
                    HStack(spacing: 5) {
                        Image(systemName: "calendar")
                        Text(dateFormatter.string(from: date))
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .opacity(reminder.isCompleted ? 0.6 : 1.0)
    }
}

