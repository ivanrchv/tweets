//
//  TweetCell.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 5.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func populate(tweet: Tweet) {
        userLabel.text = tweet.user
        dateLabel.text = tweet.date
        contentLabel.text = tweet.text
    }
}
