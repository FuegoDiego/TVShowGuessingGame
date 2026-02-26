//
//  TVShow.swift
//  TVShowGuessingGame
//
//  Created by JACKSON GERAMBIA on 2/24/26.
//

import Foundation

struct TVShow {
    var title : String
    var year : String
    var genres : [String]
    var image : String
    var id : Int
    
    init(title: String, year: String, genres: [String], image: String, id: Int) {
        self.title = title
        self.year = year
        self.genres = genres
        self.image = image
        self.id = id
    }
    
    init(id: Int) {
        self.title = ""
        self.year = ""
        self.genres = []
        self.image = ""
        self.id = id
    }
}
