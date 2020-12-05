//
//  TweetFetcher.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 5.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import Foundation

class TweetFetcher {
    //TODO: extract Bearer
    func requestTweets(keyword: String, completion: @escaping ([Dictionary<String, Any>]) -> Void) {
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?count=100&tweet_mode=extended&q=\(keyword)")!
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer AAAAAAAAAAAAAAAAAAAAAFZgKQEAAAAADiOLuLIuhW6o6UO6qY1wHc%2FMPwU%3DHQUPK1w0Mvn0gxPOiF1p433qqgPwmhxtWF8qiIheZzLuLLqJn6",
            forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String, Any>,
                    let statuses = json["statuses"] as? [Dictionary<String, Any>]
                {
                    completion(statuses)
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        task.resume()
    }
}
