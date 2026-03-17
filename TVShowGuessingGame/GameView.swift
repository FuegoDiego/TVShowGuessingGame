//
//  SwiftUIView.swift
//  TVShowGuessingGame
//
//  Created by DIEGO CHAVEZ on 2/23/26.
//

internal import Combine
import SwiftUI
import FirebaseDatabaseInternal

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
    @State var points = 0
    @State var multiplier = 2.0
    @State var time = 90
    @State var deduction = 1.0
    @State var totalPoints = 0
    @State var skip: Bool = false
    
    
    @State private var uiImage: UIImage?
    //@Binding var path: NavigationPath

    @State var goToEnd = false
    
    var user : User?

    var body: some View {
        NavigationStack {
        VStack {
            let timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
            let minutes = (time % 3600) / 60
            let seconds = time % 60
            Spacer()
            Text(String(format: "%02d:%02d", minutes, seconds))
                .foregroundStyle(.white)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(width: 100, height: 50)
                .onReceive(timer) { _ in
                    if time > 0 {
                        time -= 1
                    }
                    if time == 0 {
                        updateHighScore()
                        goToEnd = true
                    }
                    if time == 75 {
                        multiplier = 1.0
                    }
                }
            
            
            
            //checks if title has been initialized yet
            if randomShow.title == "" {
                //shows spinning with the given text
                ProgressView("Loading...")
            } else {
                
                Text("Year: \(randomShow.year)")
                    .foregroundStyle(.white)
                    .font(.title2)
                
                //displays the strings in genres with commas to separate
                Text("Genres: \(randomShow.genres.joined(separator: ", "))")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
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
                
                Button {
                    checkGuess()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 120, height: 50)
                        Text("Submit")
                            .foregroundStyle(.white)
                            .font(.title)
                        
                    }
                }
                
                
                Text(message)
                    .foregroundColor(.red)
                
                Spacer()
                Button {
                    skip = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 120, height: 50)
                        Text("Skip")
                            .foregroundStyle(.white)
                            .font(.title)
                        
                    }
                }
                
            }
            
        }
        .onAppear {
            print("View Loaded")
            getTV()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .navigationDestination(isPresented: $goToEnd) {
            EndView(
                score: $points,
                title: $randomShow.title,
                image: $randomShow.image
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .alert("Are you sure", isPresented: $skip){
            Button("Yes"){
                goToEnd = true
            }
            Button("No", role: .destructive){
                
            }
        }
    }
        

    }
    
    func updateHighScore() {

        guard let user = user else {
            print("No user passed to GameView")
            return
        }

        print("User key:", user.key)
        print("Points:", points)

        let ref = Database.database().reference()

        let scoreRef = ref.child("users").child(user.key).child("score")

        scoreRef.observeSingleEvent(of: .value) { snapshot in

            let currentScore = snapshot.value as? Int ?? 0
            print("Current Firebase score:", currentScore)

            if self.points > currentScore {

                scoreRef.setValue(self.points)
                print("New high score saved!")

            } else {
                print("Score not higher")
            }
        }
    }

    func checkGuess() {

        let cleanedGuess =
            guess
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let cleanedTitle = randomShow.title.lowercased()

        if cleanedGuess == cleanedTitle {

            message = "Correct!"
            blur = 40
            points += Int(Double(multiplier) * deduction * Double(100))
            updateHighScore()
            multiplier = 2.0
            deduction = 1.0
            goToEnd = true

        } else {

            message = "Wrong! Blur reduced."
            blur = max(blur - 2, 0)
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
                    print(randomJSON)
                    print("ahhh~")
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
    GameView()
}
