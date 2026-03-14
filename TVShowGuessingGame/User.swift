//
//  File.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 3/2/26.
//

import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import SwiftUI
import Foundation
internal import Combine

class User: ObservableObject {
    
    
    
    var key = ""
    
    
    
    var id = UUID()
    var score: Int
    var name: String
    var password: String
    
    private var ref = Database.database().reference()
    init(dict: [String: Any]) {
        if let n = dict["name"] as? String {
            name = n
        } else {
            name = ""
        }
        if let p = dict["password"] as? String {
            password = p
        } else {
            password = ""
        }

        if let s = dict["score"] as? Int {
            score = s
        } else {
            score = 0
        }

    }
    
    init(name: String, password: String, score: Int) {
        self.name = name
        self.password = password
        self.score = score
    }
    
    func saveToFirebase() {
        
        let dict: [String: Any] = [
            "name": name,
            "password": password,
            "score": score
        ]

        let newRef = ref.child("users").childByAutoId()
        newRef.setValue(dict)

        key = newRef.key ?? ""
    }
    
    func deleteFromFirebase() {
        ref.child("users").child(key).removeValue()
    }
    
    func updateFirebase(dict: [String: Any]) {
        ref.child("users").child(key).updateChildValues(dict)
    }
}
