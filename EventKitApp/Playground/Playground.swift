//
//  Playground.swift
//  EventKitApp
//
//  Created by Vini Oliveira  on 23/10/25.
//

import FoundationModels
import Playgrounds

#Playground {

        
    let instructions = """

        Você irá gerar uma frase para engajar o usuário a realizar determinada ação.
    
        A frase deve ser uma call-to-action humorada
    
        A frase deve ter um tom de frase dita por uma mãe dando bronca
    
        Utilize seus conhecientos sobre a cultura de mãe brasileira estressada
    
        A frase gerada também deve ser curta, não passando de 25 palavras
    
        Leve em consideração as seguintes frases para se basear na geração de uma nova:
    
        caso parecido com arrumar quarto ou casa: "Essa casa não se arruma sozinha", "Esse quarto está um caos total", "deixa a preguiça de lado", "eu vou contar até 3", "se não arrumar seu quarto, vai ficar de castigo"
    
        NÃO COPIE AS FRASES ACIMA, APENAS UTILIZE COMO BASE
    
        A saída deve ser apenas da frase gerada
    """
        
        

    if #available(iOS 26.0, *) {
        let session = LanguageModelSession(instructions: instructions)
        let response = try await session.respond(to: "Motive o usuário a arrumar o quarto bagunçado")

        print(response.content)
    } else {
        print("erro")
    }



            
      
        
        
    
}
