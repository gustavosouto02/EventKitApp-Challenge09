//
//  NewReminderTip.swift
//  EventKitApp
//
//  Created by Vini Oliveira  on 22/10/25.
//

import TipKit

struct NewReminderTip: Tip {
    var title: Text{
        Text("Bota novo reminder")
    }
    
    var message: Text? {
        Text("Sei que você é um esquecido. Adiciona um lembrete da sua tarefa se não o couro vai comer")
    }
    
    var image: Image?{
        Image(systemName: "text.pad.header.badge.plus")
    }
}
