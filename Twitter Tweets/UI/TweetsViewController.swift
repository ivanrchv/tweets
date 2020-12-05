//
//  ViewController.swift
//  Twitter Tweets
//
//  Created by Ivan Raychev on 4.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    let tweetManager = TweetManager(fetcher: TweetFetcher())

    @IBOutlet weak var tweetSearchBar: UISearchBar!
    @IBOutlet weak var tweetTableView: UITableView!
    
    var tweets = [Tweet]()
    
    private func updateTweets(_ tweets: [Tweet]) {
        self.tweets = tweets
        tweetTableView.reloadData()
    }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetCell else {
            return UITableViewCell()
        }
        
        cell.populate(tweet: tweets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: open URL in browser: https://twitter.com/anyuser/status/<statusid>
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TweetsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        
        //TODO: show loading
        tweetManager.getTweets(keyword: text) { [weak self] tweets in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                //TODO: hide loading, possibly handle errors
                strongSelf.updateTweets(tweets)
            }
        }
    }
}
