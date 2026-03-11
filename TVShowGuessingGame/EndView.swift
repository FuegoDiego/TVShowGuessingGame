//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/24/26.
//

import SwiftUI

struct EndView: View {

    var score: Int
    var title: String
    var image: String

    var body: some View {

        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .foregroundStyle(.white)

            Text("Score: \(score)")
                .font(.largeTitle)
                .foregroundStyle(.white)

            Text("The show was...")
                .font(.title)
                .foregroundStyle(.white)

            Text(title)
                .font(.title)
                .foregroundStyle(.white)

            AsyncImage(url: URL(string: image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } placeholder: {
                ProgressView()
            }

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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)

    }
}

/*#Preview {
    EndView()
}*/
