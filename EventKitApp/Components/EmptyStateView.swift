//
//  EmptyStateView.swift
//  EventKitApp
//
//  Created by Gustavo Souto Pereira on 17/10/25.
//

//view vazia caso não tenha nenhum reminder

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "checklist.checked")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("Nenhum lembrete")
                .font(.title2)
                .bold()
            Text("Adicione um novo lembrete usando o botão '+' no canto superior direito.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    EmptyStateView()
}
