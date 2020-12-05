//
//  Tweet.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 4.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import Foundation

struct Tweet {
    let text: String
    let user: String
    let date: String
    
    func description() -> String {
        return "text: \(text), user:\(user), date:\(date)"
    }
}
