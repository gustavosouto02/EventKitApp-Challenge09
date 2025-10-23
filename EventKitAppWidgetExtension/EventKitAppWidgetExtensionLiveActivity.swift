//
//  EventKitAppWidgetExtensionLiveActivity.swift
//  EventKitAppWidgetExtension
//
//  Created by Thiago de Jesus on 19/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import FoundationModels

struct EventKitAppWidgetExtensionLiveActivity: Widget {
    @State private var output: String = "Aqui terá uma frase gerada pelo FMs"
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NotificationsAttributes.self) { context in
            notificationView(for: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(output)
                    Text(context.state.date, style: .timer)
                        .padding(20)
                        .padding(.leading, 30)
                }
            } compactLeading: {
                Image(systemName: "clock")
                
            } compactTrailing: {
                Text(context.state.date, style: .timer)
            } minimal: {
                Text(context.state.date, style: .timer)
            }
            
        }
        
    }
    
    
    func generatePhrase(input: String) async -> String { // prvavelmente a cahamda por aqui nao vai funcionar, penso em mudar essa chamada para o arquivo que chama a live activity e armazenar numa variável bindable, que esse arquivo aqui acessará
        let instructions = """

            Dê uma frase para engajar o usuário a realizar determinada ação.
        
            A frase deve ser engraçada
        
            A frase deve ter um tom de frase dita por uma mãe dando bronca
        
            A frase gerada também deve ser curta, não passando de 25 palavras
        """
        
        
        if #available(iOS 26.0, *) {
            let session = LanguageModelSession(instructions: instructions)
            do{
                let response = try await session.respond(to: "Motive o usuário a \(input)")
                return response.content
            }catch {
                print("erro ao gerar conteúdo")
                return "tente novamente"
            }
        } else {
            return "Atualiza pro iOS 26 pra eu mostrar uma frase top aqui po"
        }
        

        
    }
    
    func notificationView(for context: ActivityViewContext<NotificationsAttributes>) -> some View {
        NotificationView(title: context.attributes.title, description: context.attributes.description, date: context.state.date)
    }
}


