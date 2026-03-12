//
//  SessionmManager.swift
//  TVShowGuessingGame
//
//  Created by JACKSON GERAMBIA on 3/12/26.
//

import Foundation
import FirebaseDatabase
import SwiftUI

class SessionmManager: ObservableObject {

    @Published var currentUser: User?
    @Published var loggedIn = false

    var ref = Database.database().reference()

    func login(user: User) {
        currentUser = user
        loggedIn = true
    }

    func logout() {
        currentUser = nil
        loggedIn = false
    }
}
