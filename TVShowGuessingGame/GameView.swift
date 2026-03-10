//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/23/26.
//

import SwiftUI
internal import Combine

struct GameView: View {
    
    @State var randomShow = TVShow(
        title: "",
        year: "",
        genres: [],
        image: "",
        id: Int.random(in: 1...10000)
        
    )
    @State var blur = 40
    @State var guess = ""
    @State var message = ""
    @State var points = 100
    @State var multiplier = 10
    @State var time = 90
    @State var deduction = 1.0
    
    
    @State private var uiImage: UIImage?
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationStack {
            VStack {
                let timer = Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                let minutes = (time % 3600) / 60
                let seconds = time % 60
                Text(String(format: "%02d:%02d", minutes, seconds))
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .frame(width: 100, height: 50)
                    .onReceive(timer){ _ in
                        if time > 0 {
                            time -= 1
                        }
                    }
                        //checks if title has been initialized yet
                        if randomShow.title == "" {
                            //shows spinning with the given text
                            ProgressView("Loading...")
                        } else {
                            
                            Text("Year: \(randomShow.year)")
                            
                            //displays the strings in genres with commas to separate
                            Text("Genres: \(randomShow.genres.joined(separator: ", "))")
                            
                            if let image = uiImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .blur(radius: CGFloat(blur))
                            }
                            
                            AsyncImage(url: URL(string: randomShow.image)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .blur(radius: CGFloat(blur))
                            } placeholder: {
                                ProgressView()
                            }
                            
                            
                            TextField("Enter TV Show Name", text: $guess)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                            
                            Button("Submit Guess") {
                                checkGuess()
                            }
                            .buttonStyle(.borderedProminent)
                            
                            
                            
                            Text(message)
                                .foregroundColor(.red)
                        }
                    }
                    .onAppear {
                        print("View Loaded")
                        getTV()
                        
                    }
            }
            
            
        }
    
        func checkGuess() {
            let cleanedGuess = guess.trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let cleanedTitle = randomShow.title.lowercased()
            
            if cleanedGuess == cleanedTitle {
                message = "Correct!"
                guess = ""
                blur = 40
                getTV()  // load new show
            } else {
                message = "Wrong! Blur reduced."
                blur = max(blur - 5, 0)
                deduction = max(deduction - 0.1, 0.0)
            }
        }
        
        func getTV() {
            
            print("Loading local JSON")
            
            if let url = Bundle.main.url(
                forResource: "shows",
                withExtension: "json"
            ),
               let data = try? Data(contentsOf: url)
            {
                
                do {
                    
                    if let jsonArray = try JSONSerialization.jsonObject(with: data)
                        as? [[String: Any]],
                       
                        let randomJSON = jsonArray.randomElement()
                    {
                        
                        let title = randomJSON["name"] as? String ?? ""
                        
                        var year = ""
                        if let premiered = randomJSON["premiered"] as? String,
                           let yearString = premiered.split(separator: "-").first
                        {
                            year = String(yearString)
                        }
                        
                        let genres = randomJSON["genres"] as? [String] ?? []
                        
                        var imageURL = ""
                        if let imageDict = randomJSON["image"] as? [String: Any] {
                            print(imageDict)
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
                            
                            self.uiImage = UIImage(named: imageURL)
                            
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
    GameView(path: .constant(NavigationPath()))
}
