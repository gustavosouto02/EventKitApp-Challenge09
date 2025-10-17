import EventKit
//
//  ReminderManager.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 16/10/25.
//
import Foundation
import SwiftUI

final class ReminderManager: ObservableObject {
    @Published var reminders: [EKReminder] = []
    @Published var accessDenied = false

    private let store = EKEventStore()

    init() {
        requestAccess()
        observeChanges()
    }

    func requestAccess() {
        store.requestFullAccessToReminders { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(
                        "Erro ao solicitar acesso: \(error.localizedDescription)"
                    )
                } else if granted {
                    print("Acesso permitido")
                    self.fetchReminders()
                } else {
                    print("Acesso negado")
                    self.accessDenied = true
                }
            }
        }
    }

    func fetchReminders() {
        let predicate = store.predicateForReminders(in: nil)
        store.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = (reminders ?? []).filter {
                    $0.dueDateComponents != nil && !$0.isCompleted
                }
            }
        }
    }

    func observeChanges() {
        NotificationCenter.default.addObserver(
            forName: .EKEventStoreChanged,
            object: store,
            queue: .main
        ) { _ in
            self.fetchReminders()
        }
    }

    func addReminder(title: String, notes: String?, date: Date) {
        let newReminder = EKReminder(eventStore: store)
        newReminder.title = title
        newReminder.notes = notes ?? ""
        newReminder.dueDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        newReminder.calendar = store.defaultCalendarForNewReminders()

        do {
            try store.save(newReminder, commit: true)
            fetchReminders()  // atualiza lista
            print("Lembrete criado com sucesso")
        } catch {
            print("Erro ao salvar:", error)
        }
    }

    func updateReminder(_ reminder: EKReminder) {
        do {
            try store.save(reminder, commit: true)
            print("Lembrete atualizado com sucesso")
        } catch {
            print("Erro ao atualizar:", error)
        }
    }

    func deleteReminder(_ reminder: EKReminder) {
        do {
            try store.remove(reminder, commit: true)
            print("Lembrete deletado com sucesso")
        } catch {
            print("Erro ao deletar:", error)
        }
    }
    
    func toggleCompletion(for reminder: EKReminder) {
        reminder.isCompleted.toggle()
        updateReminder(reminder) // Reutiliza sua função de salvar
    }
}
