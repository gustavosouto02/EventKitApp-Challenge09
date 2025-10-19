//
//  NotificationView.swift
//  ActivitiesStudys
//
//  Created by Thiago de Jesus on 17/10/25.
//

import SwiftUI

struct NotificationView: View {
    let title: String
    let description: String
    let date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(){
                Text(title)
                .font(.system(size: 24, weight: .bold))
                                Spacer()
                Text(date, style: .timer)
                    //.frame(maxWidth: 100)
                    .font(.system(size: 32, weight: .bold))
                    .padding(.trailing, 40)
            }

            HStack() {
                Text(description)
                    //.frame(maxWidth: 200)
                    .padding(.trailing, 40)
            }
        }
        .padding()
    }
}

#Preview {
    let title: String = "Limpar a casa"
    let description: String = "Como você é burro, esquecendo de limpar a casa toda vez!"
    let date: Date = Date()
    NotificationView(title: title, description: description, date: date)
}
