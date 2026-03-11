//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/24/26.
//

import FirebaseDatabase
import SwiftUI

struct LeaderboardView: View {

    @State var users = [User]()

    var ref = Database.database().reference()

    var body: some View {
        NavigationStack {
            VStack {
                Text("LEADERBOARD")
                    .font(.title)
                    .foregroundStyle(.white)
                List {
                    ForEach(users, id: \.key) { user in
                        Text("\(user.name) - \(user.score)")
                            .listRowBackground(Color.black)
                            .foregroundStyle(.white)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(Color(red: 0.21, green: 0.22, blue: 0.22)))

            }
            .background(.black)
        }
        .onAppear {
            check()
        }

        .onAppear {
            firebaseStuff()
        }
    }

    func firebaseStuff() {

        ref.child("users").observe(.childAdded) { snapshot, _ in

            guard let dict = snapshot.value as? [String: Any] else { return }

            let u = User(dict: dict)
            u.key = snapshot.key

            DispatchQueue.main.async {
                self.users.append(u)
            }
        }

        ref.child("users").observe(.childChanged) { snapshot, _ in

            guard let dict = snapshot.value as? [String: Any] else { return }

            let u = User(dict: dict)
            u.key = snapshot.key

            DispatchQueue.main.async {
                for i in 0..<users.count {
                    if users[i].key == snapshot.key {
                        users[i] = u
                        break
                    }
                }
            }
        }
    }
    func check() {
        print(users)
    }
}

#Preview {
    LeaderboardView()
}
