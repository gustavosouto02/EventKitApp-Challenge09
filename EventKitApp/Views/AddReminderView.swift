//
//  AddReminderView.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 16/10/25.
//

import EventKit
import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var reminderManager: ReminderManager
    @ObservedObject var NotificationManager: NotificationsManager

    @State private var title: String
    @State private var notes: String
    @State private var date: Date
    @State private var showDatePicker: Bool
    @State private var showTimePicker: Bool
    @State private var isDateEnabled: Bool
    @State private var isTimeEnabled: Bool

    var editReminder: EKReminder?

    private var isEditMode: Bool { editReminder != nil }

    private let smoothAnimation = Animation.easeInOut(duration: 0.25)

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "d 'de' MMMM 'de' yyyy"
        return formatter.string(from: date)
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    init(reminderManager: ReminderManager,notificationManager: NotificationsManager , editReminder: EKReminder? = nil) {
        self.reminderManager = reminderManager
        self.editReminder = editReminder
        self.NotificationManager = notificationManager

        if let reminder = editReminder {
            _title = State(initialValue: reminder.title ?? "")
            _notes = State(initialValue: reminder.notes ?? "")
            _date = State(initialValue: reminder.dueDateComponents?.date ?? Date())
            _isDateEnabled = State(initialValue: reminder.dueDateComponents != nil)
            _isTimeEnabled = State(initialValue: reminder.dueDateComponents?.hour != nil)
        } else {
            _title = State(initialValue: "")
            _notes = State(initialValue: "")
            _date = State(initialValue: Date())
            _isDateEnabled = State(initialValue: false)
            _isTimeEnabled = State(initialValue: false)
        }

        _showDatePicker = State(initialValue: false)
        _showTimePicker = State(initialValue: false)
    }

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Informações básicas
                Section {
                    TextField("Título", text: $title)
                    TextField("Notas", text: $notes)
                }

                // MARK: - Data e Hora
                Section {
                    // DATA
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Data")
                                    .font(.body)
                                    .fontWeight(.bold)
                                if isDateEnabled {
                                    Text(formattedDate)
                                        .font(.subheadline)
                                        .foregroundColor(.accentColor)
                                }
                            }

                            Spacer()

                            Toggle("", isOn: Binding(
                                get: { isDateEnabled },
                                set: { newValue in
                                    withAnimation(smoothAnimation) {
                                        isDateEnabled = newValue
                                        if newValue {
                                            isTimeEnabled = false
                                            showTimePicker = false
                                            showDatePicker = true
                                        } else {
                                            showDatePicker = false
                                            isTimeEnabled = false
                                        }
                                    }
                                }
                            ))
                            .labelsHidden()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard isDateEnabled else { return }
                            withAnimation(smoothAnimation) {
                                showDatePicker.toggle()
                                if showDatePicker { showTimePicker = false }
                            }
                        }

                        if isDateEnabled && showDatePicker {
                            DatePicker("", selection: $date, displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .environment(\.locale, Locale(identifier: "pt_BR"))
                                .padding(.top, 6)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }

                    // HORA 
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.accentColor)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Hora")
                                    .font(.body)
                                    .fontWeight(.bold)
                                if isTimeEnabled {
                                    Text(formattedTime)
                                        .font(.subheadline)
                                        .foregroundColor(.accentColor)
                                }
                            }

                            Spacer()

                            Toggle("", isOn: Binding(
                                get: { isTimeEnabled },
                                set: { newValue in
                                    withAnimation(smoothAnimation) {
                                        isTimeEnabled = newValue
                                        if newValue {
                                            isDateEnabled = true
                                            showDatePicker = false
                                            showTimePicker = true
                                        } else {
                                            showTimePicker = false
                                        }
                                    }
                                }
                            ))
                            .labelsHidden()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard isTimeEnabled else { return }
                            withAnimation(smoothAnimation) {
                                showTimePicker.toggle()
                                if showTimePicker { showDatePicker = false }
                            }
                        }

                        if isTimeEnabled && showTimePicker {
                            DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                                .datePickerStyle(.wheel)
                                .environment(\.locale, Locale(identifier: "pt_BR"))
                                .padding(.vertical, 6)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
            }
            .animation(.none, value: UUID())
            .navigationTitle(isEditMode ? "Editar Lembrete" : "Novo Lembrete")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { saveReminder() }
                        .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }

    func saveReminder() {
        if let reminder = editReminder {
            reminder.title = title
            reminder.notes = notes
            reminder.dueDateComponents = (isDateEnabled || isTimeEnabled)
                ? Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                : nil
            reminderManager.updateReminder(reminder)
        } else {
            if isDateEnabled || isTimeEnabled {
                reminderManager.addReminder(title: title, notes: notes, date: date)
            } else {
                reminderManager.addReminder(title: title, notes: notes, date: Date())
            }
            NotificationManager.scheduleNotification(title: title, description: notes, time: date)
        }
        dismiss()
    }
}
