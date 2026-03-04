//
//  ContentView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/20/26.
//

import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import SwiftUI

struct ContentView: View {

    @State var name = ""
    @State var displayName = ""

    @State var users = [User]()
    @State var currentUser: User?

    var ref = Database.database().reference()

    @State var didLoad = false

    var body: some View {
        NavigationStack {
            VStack {

                Text("TV Show Guessing Game")
                    .font(.largeTitle)
                    .foregroundStyle(.white)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue)
                        .fill(.white)
                        .frame(width: 200, height: 30)
                    TextField("Enter username:", text: $name)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                }

                Button {
                    login()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.blue)
                            .frame(width: 100, height: 30)
                        Text("Log in")
                            .foregroundStyle(.white)
                            .padding(20)
                    }
                }
                
                if currentUser != nil {
                    Text("Logged in as \(currentUser?.name ?? "")")
                        .font(.title)
                        .foregroundStyle(.white)
                } else {
                    Text("Not logged in")
                        .font(.title)
                        .foregroundStyle(.white)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(.blue)
                        .frame(width: 100, height: 30)
                    NavigationLink("Play") {
                        GameView()
                    }
                    .foregroundStyle(.white)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(.blue)
                        .frame(width: 150, height: 30)

                    NavigationLink("Leaderboard") {
                        LeaderboardView()
                    }
                    .foregroundStyle(.white)
                    .padding(20)
                    .contentShape(Capsule())

                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)

        }
        .onAppear {
            if !didLoad {
                firebaseStuff()
                didLoad = true
            }
        }
    }

    func login() {

        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let query = ref.child("users")
            .queryOrdered(byChild: "name")
            .queryEqual(toValue: name)

        query.observeSingleEvent(of: .value) { snapshot, _ in

            guard let snapshot = snapshot as? DataSnapshot else { return }

            if snapshot.exists(),
               let first = snapshot.children.allObjects.first as? DataSnapshot,
               let data = first.value as? [String: Any] {

                let u = User(dict: data)
                u.key = first.key

                DispatchQueue.main.async {
                    self.currentUser = u
                    self.displayName = u.name
                }

            } else {

                let u = User(name: name, score: 0)
                u.saveToFirebase()

                DispatchQueue.main.async {
                    self.currentUser = u
                    self.displayName = name
                }
            }
        }
    }

    func firebaseStuff() {
        ref.child("users").observe(
            .childAdded,
            with: { (snapshot) in

                let d = snapshot.value as? [String: Any]
                let u = User(dict: d ?? ["": ""])
                u.key = snapshot.key

                DispatchQueue.main.async {
                    self.users.append(u)
                }

            }

        )

        ref.child("users").observe(
            .childChanged,
            with: { (snapshot) in

                let u = User(
                    dict: snapshot.value as? [String: Any] ?? ["": ""]
                )

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

        )
    }
}

#Preview {
    ContentView()
}
