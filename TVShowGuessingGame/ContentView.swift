//
//  ContentView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/20/26.
//

import SwiftUI

struct ContentView: View {
    
    @State var name = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            
            Text("TV Show Guessing Game")
            
            TextField("Username", text: $name)
            
            TextField("Password", text: $password)
            
            NavigationLink("Play"){
                GameView()
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
