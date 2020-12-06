//
//  TweetManager.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 5.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import Foundation

enum TweetResult {
    case success([Tweet])
    case error(String)
}

class TweetManager {
    private let fetcher: TweetFetching
    private let incomingDateFormatter = DateFormatter()
    private let displayDateFormatter = DateFormatter()
    
    init(fetcher: TweetFetching) {
        self.fetcher = fetcher
        self.setupDateFormatters()
    }
    
    func getTweets(keyword: String, completion: @escaping (TweetResult) -> Void) {
        fetcher.requestTweets(keyword: keyword) { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .error(let errorText):
                completion(.error(errorText))
                
            case .success(let json):
                if let statuses = json["statuses"] as? [Dictionary<String, Any>] {
                    completion(.success(strongSelf.tweetsFromArray(statuses)))
                } else {
                    completion(.error("bad json"))
                }
            }
        }
    }
    
    private func tweetsFromArray(_ array: [Dictionary<String, Any>]) -> [Tweet] {
        return array.compactMap { tweetFromDict($0) }
    }
    
    private func tweetFromDict(_ dict: Dictionary<String, Any>) -> Tweet? {
        guard let text = dict["full_text"] as? String,
            let userDict = dict["user"] as? Dictionary<String, Any>,
            let user = userDict["name"] as? String,
            let rawDate = dict["created_at"] as? String,
            let date = convertDateStringFormat(rawDate),
            let rawId = (dict["id"]) else { return nil }
        
        let id = "\(rawId)"
        return Tweet(text: text, user: user, date: date, id: id)
    }

    private func setupDateFormatters() {
        incomingDateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        displayDateFormatter.dateStyle = .medium
        displayDateFormatter.timeStyle = .short
    }
    
    private func convertDateStringFormat(_ string: String) -> String? {
        guard let date = incomingDateFormatter.date(from:string) else { return nil }
        
        return displayDateFormatter.string(from: date)
    }
}
