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
    @State var path = NavigationPath()
    @State var users = [User]()
    @State var currentUser: User?

    var ref = Database.database().reference()

    @State var didLoad = false
    
    @State var loggedIn = false

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
                        .frame(width: 280, height: 50)
                    TextField("Enter username:", text: $name)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .font(.title)
                }

                Button {
                    login()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 120, height: 50)
                        Text("Log in")
                            .foregroundStyle(.white)
                            .font(.title)
                            
                        
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

                NavigationLink(destination: GameView(path: $path)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(loggedIn ? .blue : .gray)
                            .frame(width: 120, height: 50)
                        Text("Play")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                }
                .disabled(loggedIn == false)
               
                
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
               let first = snapshot.children.allObjects.first as? DataSnapshot,let data = first.value as? [String: Any] {
                print(type(of: first.value))
                print(data)
                let u = User(dict: data)
                u.key = first.key

                DispatchQueue.main.async {
                    self.currentUser = u
                    self.displayName = u.name
                    self.loggedIn = true
                }

            } else {

                let u = User(name: name, score: 0)
                u.saveToFirebase()

                DispatchQueue.main.async {
                    self.currentUser = u
                    self.displayName = name
                    self.loggedIn = true
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
