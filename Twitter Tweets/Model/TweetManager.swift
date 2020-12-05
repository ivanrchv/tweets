//
//  TweetManager.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 5.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import Foundation

class TweetManager {
    private let fetcher: TweetFetcher
    private let incomingDateFormatter = DateFormatter()
    private let displayDateFormatter = DateFormatter()
    
    init(fetcher: TweetFetcher) {
        self.fetcher = fetcher
        self.setupDateFormatters()
    }
    
    func getTweets(keyword: String, completion: @escaping ([Tweet]) -> Void) {
        fetcher.requestTweets(keyword: keyword) { [weak self] (tweets) in
            guard let strongSelf = self else { return }
            completion(strongSelf.tweetsFromArray(tweets))
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
            let date = convertDateStringFormat(rawDate) else { return nil }
        
        return Tweet(text: text, user: user, date: date)
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
