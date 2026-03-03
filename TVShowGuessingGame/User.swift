//
//  File.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 3/2/26.
//

import Foundation
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class User {
    var key = ""
    var ref = Database.database().reference()
    var id = UUID()
    var name: String
    var points: Int
    init(dict: [String:Any]) {
        if let n = dict["name"] as? String{
                name = n
        }else{
            name = ""
        }
        if let p = dict["points"] as? Int{
            points = p
        }else{
            points = 0
        }
        
    }
    func saveToFirebase() {
        //create a dictionary
        let dic = ["name": name, "points": points] as [String: Any]
        ref.child("users").childByAutoId().setValue(dic)
        key = ref.child("users").childByAutoId().key ?? "0"
    }
    func deleteFromFirebase() {
        ref.child("users").child(key).removeValue()
    }
    func updateFirebase(dict: [String: Any]) {
        ref.child("users").child(key).updateChildValues(dict)
    }
}
