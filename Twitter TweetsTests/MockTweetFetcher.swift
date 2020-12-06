//
//  MockTweetFetcher.swift
//  Twitter TweetsTests
//
//  Created by Ivan Raychev on 6.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

@testable import Twitter_Tweets

class MockTweetFetcher: TweetFetching {
    enum Configuration: String {
        case standart
        case emptyDict
        case dictWithEmptyArray
        case invalidTweets
        case fetchingError
        
        func jsonDict() -> Dictionary<String, Any>? {
            switch self {
            case .standart:
                return [
                    "statuses": [
                        ["id_str": "1111", "full_text": "Test tweet 1", "created_at": "Fri Dec 04 13:04:05 +0000 2020", "user": ["name": "User1"]],
                        ["id_str": "2222", "full_text": "Test tweet 2", "created_at": "Fri Dec 04 13:04:05 +0000 2020", "user": ["name": "User2"]],
                        ["id_str": "3333", "full_text": "Test tweet 3", "created_at": "Fri Dec 04 13:04:05 +0000 2020", "user": ["name": "User3"]]
                    ]
                ]
                
            case .emptyDict:
                return [:]
                
            case .dictWithEmptyArray:
                return ["statuses": []]
                
            case .invalidTweets:
                return [
                    "statuses": [
                        ["id_str": "1111", "full_text": "Test tweet 1", "created_at": "Fri Dec 04 13:04:05 +0000 2020"],
                        ["id_str": "2222", "full_text": "Test tweet 2", "user": ["name": "User2"]],
                        ["id_str": "3333", "created_at": "Fri Dec 04 13:04:05 +0000 2020", "user": ["name": "User3"]],
                        ["full_text": "Test tweet 4", "created_at": "Fri Dec 04 13:04:05 +0000 2020", "user": ["name": "User4"]]
                    ]
                ]
                
            case .fetchingError:
                return nil
            }
        }
    }
    
    func requestTweets(keyword: String, completion: @escaping (TweetResponse) -> Void) {
        if let dict = Configuration(rawValue: keyword)?.jsonDict() {
            completion(.success(dict))
        } else {
            completion(.error("fetching error"))
        }
    }
}
