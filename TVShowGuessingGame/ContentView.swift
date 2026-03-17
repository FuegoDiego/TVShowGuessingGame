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
    @State var pass = ""

    @State var users = [User]()
    @State var currentUser: User?

    var ref = Database.database().reference()

    @State var didLoad = false

    @State var loggedIn = false

    @State var showAlert = false
    @State var alertMessage = ""

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
                    TextField("Username:", text: $name)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .font(.title)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding(.vertical, 20)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue)
                        .fill(.white)
                        .frame(width: 280, height: 50)
                    SecureField("Password:", text: $pass)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .font(.title)
                }

                HStack {
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
                    .padding(.vertical,20)
                    Button {
                        createAccount()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.blue)
                                .frame(width: 220, height: 50)
                            Text("Create Account")
                                .foregroundStyle(.white)
                                .font(.title)

                        }
                    }
                }

                if currentUser != nil {
                    Text("Logged in as \(currentUser?.name ?? "")")
                        .font(.title)
                        .foregroundStyle(.white)
                    Text("Your highscore: \(currentUser?.score ?? 0)")
                        .font(.title)
                        .foregroundStyle(.white)

                } else {
                    Text("Not logged in")
                        .font(.title)
                        .foregroundStyle(.white)
                }

                NavigationLink(destination: GameView(user: currentUser ?? User(dict: ["":""]))) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(loggedIn ? .green : .gray)
                            .frame(width: 200, height: 100)
                        Text("Play")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                    .disabled(loggedIn == false)
                }
                .disabled(loggedIn == false)
                .padding(.vertical, 20)

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

            
                
                Button {
                    UserDefaults.standard.removeObject(forKey: "loggedInUser")

                    currentUser = nil
                    loggedIn = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.red)
                            .frame(width: 120, height: 50)
                        Text("Log out")
                            .foregroundStyle(.white)
                            .font(.title)

                    }
                }
                .padding(.top, 50)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .alert("Notice", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }

        }
        .onAppear {
            if !didLoad {
                firebaseStuff()
                autoLogin()
                didLoad = true
            }
        }
    }

    func login() {

        guard !name.isEmpty, !pass.isEmpty else { return }

        let query = ref.child("users")
            .queryOrdered(byChild: "name")
            .queryEqual(toValue: name)

        query.observeSingleEvent(of: .value) { snapshot, _ in

            guard let snapshot = snapshot as? DataSnapshot else { return }

            if snapshot.exists(),
                let first = snapshot.children.allObjects.first as? DataSnapshot,
                let data = first.value as? [String: Any]
            {

                let u = User(dict: data)
                u.key = first.key

                if u.password == pass {

                    DispatchQueue.main.async {
                        self.currentUser = u
                        self.displayName = u.name
                        self.loggedIn = true

                        UserDefaults.standard.set(name, forKey: "loggedInUser")
                    }

                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Incorrect password."
                        self.showAlert = true
                    }
                }

            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "User does not exist."
                    self.showAlert = true
                }
            }
        }
    }

    func createAccount() {

        guard !name.isEmpty, !pass.isEmpty else { return }

        let query = ref.child("users")
            .queryOrdered(byChild: "name")
            .queryEqual(toValue: name)

        query.observeSingleEvent(of: .value) { snapshot, _ in

            guard let snapshot = snapshot as? DataSnapshot else { return }

            if snapshot.exists() {

                DispatchQueue.main.async {
                    self.alertMessage = "That username is already taken."
                    self.showAlert = true
                }

            } else {

                let u = User(name: name, password: pass, score: 0)
                u.saveToFirebase()

                DispatchQueue.main.async {
                    self.currentUser = u
                    self.displayName = name
                    self.loggedIn = true

                    UserDefaults.standard.set(self.name, forKey: "loggedInUser")
                }

                DispatchQueue.main.async {
                    self.alertMessage = "Account created successfully!"
                    self.showAlert = true
                }
            }
        }
    }

    func autoLogin() {

        if let savedName = UserDefaults.standard.string(forKey: "loggedInUser")
        {

            let query = ref.child("users")
                .queryOrdered(byChild: "name")
                .queryEqual(toValue: savedName)

            query.observeSingleEvent(of: .value) { snapshot, _ in

                guard let snapshot = snapshot as? DataSnapshot else { return }

                if snapshot.exists(),
                    let first = snapshot.children.allObjects.first
                        as? DataSnapshot,
                    let data = first.value as? [String: Any]
                {

                    let u = User(dict: data)
                    u.key = first.key

                    DispatchQueue.main.async {
                        self.currentUser = u
                        self.displayName = u.name
                        self.loggedIn = true
                    }
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
