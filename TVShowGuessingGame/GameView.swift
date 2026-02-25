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
        year: 0,
        genres: [],
        image: "",
        id: Int.random(in: 1...10000)
    )

    var body: some View {
        VStack {
            //checks if title has been initialized yet
            if randomShow.title == "" {
                //shows spinning with the given text
                ProgressView("Loading...")
            } else {
                Text(randomShow.title)
                    .font(.title)
                    .bold()

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
            getTV()
        }

    }

    func getTV() {
        let session = URLSession.shared

        guard
            let url = URL(
                string: "https://api.tvmaze.com/shows/\(randomShow.id)"
            )
        else { return }

        let dataTask = session.dataTask(with: url) { data, response, error in

            if let error = error {
                print("Error:\n\(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode != 200
            {
                DispatchQueue.main.async {
                    self.randomShow.id = Int.random(in: 1...10000)
                }
                getTV()
                return
            }

            if let data = data {

                if let jsonObj = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                ) as? NSDictionary {

                    var title = ""
                    var year = 0
                    var genres: [String] = []
                    var imageURL = ""

                    if let name = jsonObj["name"] as? String {
                        title = name
                    }

                    if let premiered = jsonObj["premiered"] as? String {
                        if let yearString = premiered.split(separator: "-")
                            .first
                        {
                            year = Int(yearString) ?? 0
                        }
                    }

                    if let genreArray = jsonObj["genres"] as? [String] {
                        genres = genreArray
                    }

                    if let imageDict = jsonObj["image"] as? NSDictionary,
                        let original = imageDict["original"] as? String
                    {
                        imageURL = original
                    }

                    DispatchQueue.main.async {
                        self.randomShow = TVShow(
                               title: title,
                               year: year,
                               genres: genres,
                               image: imageURL,
                               id: self.randomShow.id
                        )
                        
                        print("Stored show:", self.randomShow.title)
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
