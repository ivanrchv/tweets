//
//  ViewController.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 4.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestTweets(keyword: "test") { (tweets) in
            for tweet in tweets {
                print(tweet.description())
                print("----------------")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func requestTweets(keyword: String, completion: @escaping ([Tweet]) -> Void) {
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?count=100&q=\(keyword)")!
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
                    completion(Tweet.fromArray(statuses))
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
