//
//  ViewController.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 4.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tweetManager = TweetManager(fetcher: TweetFetcher())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tweetManager.getTweets(keyword: "test") { (tweets) in
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
}
