//
//  Tweet.swift
//  Twitter Tweets
//
//  Created by Dev on 4.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import Foundation

struct Tweet {
    let text: String
    let user: String
    let date: String
    
    static func fromArray(_ array: [Dictionary<String, Any>]) -> [Tweet] {
        return array.compactMap { Tweet.fromDict($0) }
    }
    
    static func fromDict(_ dict: Dictionary<String, Any>) -> Tweet? {
        guard let text = dict["text"] as? String,
            let userDict = dict["user"] as? Dictionary<String, Any>,
            let user = userDict["name"] as? String,
            let date = dict["created_at"] as? String else { return nil }
        
        return Tweet(text: text, user: user, date: date)
    }
    
    func description() -> String {
        return "text: \(text), user:\(user), date:\(date)"
    }
}
