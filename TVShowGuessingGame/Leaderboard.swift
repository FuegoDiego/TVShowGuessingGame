//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/24/26.
//

import SwiftUI

struct LeaderboardView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("HIGHSCORE")
                    .font(.title)
                    .foregroundStyle(.white)
                List{
                    ForEach(1...3, id: \.self){ i in
                        Text("Placeholder \(i)")
                            .listRowBackground(Color.black)
                            .foregroundStyle(.white)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(Color(red: 0.21, green: 0.22, blue: 0.22)))
            }
            .background(.black)
        }
    }
}

#Preview {
    LeaderboardView()
}
