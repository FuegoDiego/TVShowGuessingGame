//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/24/26.
//

import SwiftUI

struct LeaderboardView: View {

    @State var users = [User]()

    var body: some View {

        NavigationStack {
            VStack {
                Text("LEADERBOARD")
                    .font(.title)
                    .foregroundStyle(.white)
                List {
                    ForEach(users, id: \.id) { user in
                        Text("\(user.name) - \(user.score)")
                            .listRowBackground(Color.black)
                            .foregroundStyle(.white)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(Color(red: 0.21, green: 0.22, blue: 0.22)))
                
            }
            .background(.black)
            .onAppear{
                check()
            }
        }
    }
    func check(){
        print(users)
    }
}

#Preview {
    LeaderboardView()
}
