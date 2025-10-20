//
//  LiveActivitieManager.swift
//  ActivitiesStudys
//
//  Created by Thiago de Jesus on 19/10/25.
//

import Foundation
import ActivityKit

/// Gerencia Live Activities relacionadas a notificações usando ActivityKit.
///
/// Esta classe implementa um padrão Singleton para iniciar e encerrar
/// Live Activities baseadas em `NotificationsAttributes`.
class LiveActivitieManager {
    
    /// Instância compartilhada (Singleton) para acesso global controlado.
    static var shared = LiveActivitieManager()
    /// Inicializador privado para garantir o padrão Singleton.
    private init(){
    }
        
    /// Inicia uma Live Activity com base nos dados do formulário de notificação.
    ///
    /// - Parameter liveModel: Modelo contendo `title` e `description` para popular
    ///   `NotificationsAttributes`.
    ///
    /// Cria um `Activity<NotificationsAttributes>` com estado inicial contendo a
    /// data atual. Caso a requisição falhe, o erro é impresso no console.
    func startLiveActivity(model liveModel: NotificationFormModel){
        // Monta os atributos da Live Activity a partir do modelo fornecido.
        let notification = NotificationsAttributes(title: liveModel.title, description: liveModel.description)
        // Define a data atual para o estado inicial.
        let date = Date()
        // Cria o conteúdo inicial da atividade (sem `staleDate`).
        let initialContentState = ActivityContent(state: NotificationsAttributes.ContentState(date: date), staleDate: nil)
        do{
            // Solicita o início da Live Activity.
            _ = try Activity<NotificationsAttributes>.request(attributes: notification, content: initialContentState)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    /// Encerra a Live Activity mais recente, se existir.
    ///
    /// Utiliza `Activity<NotificationsAttributes>.activities.last` e solicita o
    /// encerramento com `dismissalPolicy: .immediate`.
    func stopLiveActivity(){
        // Obtém a última atividade ativa para encerrá-la.
        if let activity = Activity<NotificationsAttributes>.activities.last{
            Task {
                // Encerra a atividade imediatamente.
                await activity.end(activity.content, dismissalPolicy: .immediate)
            }
        }
    }
}

