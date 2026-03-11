//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/24/26.
//

import SwiftUI

struct EndView: View {
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Text("Score:")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                NavigationLink(destination: ContentView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 150, height: 50)
                        
                        Text("Home")
                            .foregroundStyle(.white)
                            .font(.title)
                        
                    }
                }
                
                NavigationLink(destination: LeaderboardView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 200, height: 50)
                        
                        Text("Leaderboard")
                            .foregroundStyle(.white)
                            .font(.title)
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        }
        
    }
}

#Preview {
    EndView()
}
