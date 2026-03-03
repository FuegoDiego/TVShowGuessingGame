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
import Foundation

class User {
    
    var key = ""
    
    var ref = Database.database().reference()
    
    var id = UUID()
    
    var name: String
    var score: Int

    init(dict: [String: Any]) {
        if let n = dict["name"] as? String {
            name = n
        } else {
            name = ""
        }
        if let s = dict["score"] as? Int {
            score = s
        } else {
            score = 0
        }

    }
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
    
    func saveToFirebase() {
        let dic: [String: Any] = [
            "name": name,
            "score": score,
        ]

        let newRef = ref.child("users").childByAutoId()
        newRef.setValue(dic)

        key = newRef.key ?? ""
    }
    
    func deleteFromFirebase() {
        ref.child("users").child(key).removeValue()
    }
    
    func updateFirebase(dict: [String: Any]) {
        ref.child("users").child(key).updateChildValues(dict)
    }
}
