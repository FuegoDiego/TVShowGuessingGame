//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/23/26.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
     func getTV() {
        let session = URLSession.shared
        
        let randomID = Int.random(in: 1...50000)
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(randomID)") else { return }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error:\n\(error)")
                return
            }
            
          
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                getTV()
                return
            }
            
            if let data = data {
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    print("Full JSON:")
                    print(jsonObj)
                    
                    if let name = jsonObj["name"] as? String {
                        print("Show name: \(name)")
                    }
                    
                    if let imageDict = jsonObj["image"] as? NSDictionary,
                       let imageURL = imageDict["original"] as? String {
                        print("Poster URL: \(imageURL)")
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}

#Preview {
    GameView()
}
