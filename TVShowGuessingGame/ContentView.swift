//
//  ContentView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/20/26.
//

import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseInternal
import FirebaseFirestore
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
            VStack{
            
                
                Text("TV Show Guessing Game")
                .font(.largeTitle)
                .foregroundStyle(.white)
                
                ZStack{
                    Capsule()
                        .stroke(.blue)
                        .fill(.white)
                        .frame(width: 200 ,height: 30)
                    TextField("Enter username:", text: $name)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                }
                
                Button {
                    
                } label: {
                    ZStack{
                        Capsule()
                            .fill(.blue)
                            .frame(width: 100 ,height: 30)
                        Text("Log in")
                            .foregroundStyle(.white)
                            .padding(20)
                    }
                }
                
                ZStack{
                    Capsule()
                        .fill(.blue)
                        .frame(width: 100 ,height: 30)
                    NavigationLink("Play"){
                        GameView()
                    }
                    .foregroundStyle(.white)
                }
                ZStack{
                    Capsule()
                        .fill(.blue)
                        .frame(width: 150 ,height: 30)
                    
                    NavigationLink("Leaderboard"){
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
    func firebaseStuff() {
        ref.child("users").observe(
            .childAdded,
            with: { (snapshot) in

                let d = snapshot.value as? [String: Any]
                let u = User(stuff: d ?? ["": ""])
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
                    stuff: snapshot.value as? [String: Any] ?? ["": ""]
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
