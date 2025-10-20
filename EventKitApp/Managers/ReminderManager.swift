import EventKit
//
//  ReminderManager.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 16/10/25.
//
import Foundation
import SwiftUI

///final class não pode ser herdada; ideal para um manager.
final class ReminderManager: ObservableObject {
    @Published var reminders: [EKReminder] = []
    @Published var accessDenied = false

    private let store = EKEventStore()

    init() {
        requestAccess()
        observeChanges()
    }
    
///solicita acesso aos reminders.
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

    /// busca os reminders existentes no app nativo, desde que atendam às condições definidas.
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

    ///observa mudanças nos reminders, dessa forma o app consegue sincronizar com essas alterações.
    func observeChanges() {
        NotificationCenter.default.addObserver(
            forName: .EKEventStoreChanged,
            object: store,
            queue: .main
        ) { _ in
            self.fetchReminders()
        }
    }

    ///permite adicionar reminders e registrá-los no nosso app e no app nativo.
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

    /// atualiza reminders.
    func updateReminder(_ reminder: EKReminder) {
        do {
            try store.save(reminder, commit: true)
            print("Lembrete atualizado com sucesso")
        } catch {
            print("Erro ao atualizar:", error)
        }
    }
    
  ///função para excluir um reminder, tanto do nosso app quanto do app nativo.
    func deleteReminder(_ reminder: EKReminder) {
        do {
            try store.remove(reminder, commit: true)
            print("Lembrete deletado com sucesso")
        } catch {
            print("Erro ao deletar:", error)
        }
    }
    
    ///alterna o status de conclusão de um lembrete.
    func toggleCompletion(for reminder: EKReminder) {
        reminder.isCompleted.toggle()
        updateReminder(reminder) // Reutiliza função de salvar
        
        //Se o lembrete foi concluido, encerra a Live Activity
               if reminder.isCompleted{
                   LiveActivitieManager.shared.stopLiveActivity()
               }

    }
}
