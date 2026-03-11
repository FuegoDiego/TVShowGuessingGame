//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/24/26.
//

import SwiftUI

struct EndView: View {
    @Environment(\.dismiss) var dismiss
    //@Binding var path: NavigationPath
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.title)
            Text("Score:")
            
            Button("Home"){
                
            }
        }
        
    }
}

#Preview {
    EndView()
}
