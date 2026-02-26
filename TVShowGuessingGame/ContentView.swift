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
        NavigationStack {
            VStack{
            
                
                Text("TV Show Guessing Game")
                .font(.title)
                .foregroundStyle(.white)
                ZStack{
                    Capsule()
                        .stroke(.white)
                        .frame(width: 200 ,height: 30)
                    TextField("Username", text: $name)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                }
                Spacer()
                    .frame(width: 1, height: 15)
                
                ZStack{
                    Capsule()
                        .stroke(.white)
                        .frame(width: 200 ,height: 30)
                    TextField("Password", text: $password)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                }
            Spacer()
            .frame(width: 1, height: 30)
            
                
                ZStack{
                    Capsule()
                        .fill(.blue)
                        .frame(width: 100 ,height: 30)
                    NavigationLink("Play"){
                        GameView()
                    }
                    .foregroundStyle(.white)
                }
                Spacer()
                    .frame(width: 1, height: 15)
                ZStack{
                    Capsule()
                        .fill(.blue)
                        .frame(width: 150 ,height: 30)
                    
                    NavigationLink("Leaderboard"){
                        LeaderboardView()
                    }
                    .foregroundStyle(.white)
                    .padding(50)
                    .contentShape(Capsule())
                    
                }
                
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            
            
            
           
        }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }
}

#Preview {
    ContentView()
}
