//
//  AddReminderView.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 16/10/25.
//
// AddReminderView.swift

import EventKit
import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var reminderManager: ReminderManager

    @State private var title: String
    @State private var notes: String
    @State private var date: Date
    @State private var showDatePicker: Bool
    @State private var showTimePicker: Bool

    var editReminder: EKReminder?

    private var isEditMode: Bool {
        editReminder != nil
    }

    init(reminderManager: ReminderManager, editReminder: EKReminder? = nil) {
        self.reminderManager = reminderManager
        self.editReminder = editReminder

        if let reminder = editReminder {
            _title = State(initialValue: reminder.title ?? "")
            _notes = State(initialValue: reminder.notes ?? "")
            _date = State(initialValue: reminder.dueDateComponents?.date ?? Date())
            _showDatePicker = State(initialValue: true)
            _showTimePicker = State(initialValue: false)
 
        } else {
            _title = State(initialValue: "")
            _notes = State(initialValue: "")
            _date = State(initialValue: Date())
            _showDatePicker = State(initialValue: false)
            _showTimePicker = State(initialValue: false)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Título", text: $title)
                    TextField("Notas", text: $notes)
                }

                Section {
                    Toggle("Data", isOn: createBinding(for: $showDatePicker))
                    if showDatePicker {
                        DatePicker(
                            "Escolha a data",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .environment(\.locale, Locale(identifier: "pt_BR"))
                        .transition(.slide)
                    }

                    Toggle("Hora", isOn: createBinding(for: $showTimePicker))
                    if showTimePicker {
                        DatePicker(
                            "Escolha a hora",
                            selection: $date,
                            displayedComponents: [.hourAndMinute]
                        )
                        .datePickerStyle(.wheel)
                        .environment(\.locale, Locale(identifier: "pt_BR"))
                        .transition(.slide)
                    }
                }
            }
            .navigationBarTitle(isEditMode ? "Editar Lembrete" : "Novo Lembrete")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveReminder()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    func saveReminder() {
        if let reminder = editReminder {
            reminder.title = title
            reminder.notes = notes
            reminder.dueDateComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: date
            )
            reminderManager.updateReminder(reminder)
        } else {
            reminderManager.addReminder(title: title, notes: notes, date: date)
        }
        dismiss()
    }
    
    // Função auxiliar para os Toggles com animação (sem mudanças)
    private func createBinding(for state: Binding<Bool>) -> Binding<Bool> {
        Binding(
            get: { state.wrappedValue },
            set: { newValue in
                withAnimation {
                    state.wrappedValue = newValue
                    if state.wrappedValue {
                        if state.wrappedValue == showDatePicker { showTimePicker = false }
                        if state.wrappedValue == showTimePicker { showDatePicker = false }
                    }
                }
            }
        )
    }
}

#Preview {
    AddReminderView(reminderManager: ReminderManager())
}
