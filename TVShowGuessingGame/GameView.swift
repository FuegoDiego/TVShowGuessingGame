//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/23/26.
//

import SwiftUI

struct GameView: View {

    @State var randomShow = TVShow(
        title: "",
        year: "",
        genres: [],
        image: "",
        id: Int.random(in: 1...10000)
    )

    var body: some View {
        NavigationStack {
            VStack {
                //checks if title has been initialized yet
                if randomShow.title == "" {
                    //shows spinning with the given text
                    ProgressView("Loading...")
                } else {
                    
                    Text("Year: \(randomShow.year)")
                    
                    //displays the strings in genres with commas to separate
                    Text("Genres: \(randomShow.genres.joined(separator: ", "))")
                    
                    AsyncImage(url: URL(string: randomShow.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .onAppear {
                print("View Loaded")
                getTV()
                
            }
        }

    }
    
    func getTV() {

        print("Loading local JSON")

        if let url = Bundle.main.url(forResource: "shows", withExtension: "json"),
           let data = try? Data(contentsOf: url) {

            do {

                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],

                   let randomJSON = jsonArray.randomElement() {

                    let title = randomJSON["name"] as? String ?? ""

                    var year = ""
                    if let premiered = randomJSON["premiered"] as? String,
                       let yearString = premiered.split(separator: "-").first {
                        year = premiered
                    }

                    let genres = randomJSON["genres"] as? [String] ?? []

                    var imageURL = ""
                    if let imageDict = randomJSON["image"] as? [String: Any] {
                        imageURL = imageDict["original"] as? String ?? ""
                    }

                    DispatchQueue.main.async {
                        self.randomShow = TVShow(
                            title: title,
                            year: year,
                            genres: genres,
                            image: imageURL,
                            id: self.randomShow.id
                        )

                        print("Loaded local show:", title)
                    }
                }

            } catch {
                print("JSON parse error:", error)
            }
        }
    }
    
}

#Preview {
    GameView()
}
