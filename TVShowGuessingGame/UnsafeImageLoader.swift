//
//  UnsafeImageLoader.swift
//  TVShowGuessingGame
//
//  Created by JACKSON GERAMBIA on 2/27/26.
//

import Foundation
import UIKit

class UnsafeImageLoader: NSObject, URLSessionDelegate {

    static let shared = UnsafeImageLoader()

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let config = URLSessionConfiguration.default

        let session = URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: nil
        )

        let task = session.dataTask(with: url) { data, _, _ in
            if let data = data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
}
