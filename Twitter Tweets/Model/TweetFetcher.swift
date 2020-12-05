//
//  TweetFetcher.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 5.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import Foundation

enum TweetResponse {
    case success([Dictionary<String, Any>])
    case error(String)
}

class TweetFetcher {
    func requestTweets(keyword: String, completion: @escaping (TweetResponse) -> Void) {
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?count=100&tweet_mode=extended&q=\(keyword)"
        guard let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: escapedString) else {
            completion(.error("failed to build url"))
            return
        }
        
        var request = URLRequest(url: url)
        let bearer = "AAAAAAAAAAAAAAAAAAAAAFZgKQEAAAAADiOLuLIuhW6o6UO6qY1wHc%2FMPwU%3DHQUPK1w0Mvn0gxPOiF1p433qqgPwmhxtWF8qiIheZzLuLLqJn6"
        request.setValue( "Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    completion(.error(error?.localizedDescription ?? "unknown error"))
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                completion(.error("statusCode should be 2xx, but is \(response.statusCode)"))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String, Any>,
                    let statuses = json["statuses"] as? [Dictionary<String, Any>] {
                    completion(.success(statuses))
                } else {
                    completion(.error("bad json"))
                }
            } catch let error as NSError {
                completion(.error(error.localizedDescription))
            }
        }
        
        task.resume()
    }
}
