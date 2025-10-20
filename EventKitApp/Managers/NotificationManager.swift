//
//  NotificationManager.swift
//  ActivitiesStudys
//
//  Created by Thiago de Jesus on 19/10/25.
//

import Foundation
import UserNotifications

/// Gerencia permissões e agendamentos de notificações locais usando UserNotifications.
///
/// - Responsável por:
///   - Solicitar autorização de notificações na inicialização.
///   - Agendar notificações recorrentes com base em hora, minuto e dia da semana.
///   - Anexar metadados em `userInfo` para acionar ações no app (ex.: iniciar Live Activity).
class NotificationsManager: ObservableObject {
    
    /// Inicializa o gerenciador e solicita a autorização do usuário para enviar notificações.
    ///
    /// Chama internamente `requestAuthorization()` para garantir que o app tenha permissão
    /// para exibir alertas, badges e sons.
    init(){
        requestAuthorization()
    }

    /// Agenda uma notificação local recorrente para um dia da semana e horário específicos.
    ///
    /// - Parameters:
    ///   - title: Título exibido na notificação.
    ///   - description: Subtítulo/descrição exibida na notificação.
    ///   - time: `Date` usado apenas para extrair `weekday`, `hour` e `minute`.
    ///
    /// A notificação é criada com `UNCalendarNotificationTrigger` e `repeats = true`,
    /// portanto será disparada semanalmente no dia e horário informados. Metadados são
    /// adicionados em `content.userInfo` para permitir ações no app (ex.: `startLiveActivity`).
    func scheduleNotification(title: String, description: String ,time: Date){
        // Monta o conteúdo da notificação (título, subtítulo, som e metadados).
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = description
        content.sound = .default
        content.userInfo = ["action": "startLiveActivity"]
        content.userInfo["title"] = title
        content.userInfo["description"] = description
        
        // Extrai hora, minuto e dia da semana a partir de `time`.
        let calendar = Calendar.current
         let components = calendar.dateComponents([.hour, .minute, .weekday], from: time)

         guard let hour = components.hour,
               let minute = components.minute,
               let day = components.weekday else { return }
        
        // Constrói os componentes de data para o gatilho recorrente semanal.
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.weekday = day
        // Define o gatilho com repetição semanal.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents , repeats: true)
        
        // Observação: Para notificações por localização, utilize gatilhos baseados em região (CLRegion).
        
        // Cria e agenda o pedido de notificação no UNUserNotificationCenter.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("criou a notificação")
        print("dia: \(day), minuto: \(minute), hora: \(hour)")
    }

    /// Solicita autorização do sistema para enviar notificações.
    ///
    /// Pede permissão para `alert`, `badge` e `sound`. O resultado é impresso no console
    /// apenas para depuração.
    private func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if error != nil {
                print("Error")
            } else {
                print("Sucess")
            }
        }
    }
}
