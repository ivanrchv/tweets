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
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var tweets = [Tweet]()
    
    private func updateTweets(_ tweets: [Tweet]) {
        self.tweets = tweets
        tweetTableView.reloadData()
    }
    
    private func showError(_ errorText: String) {
        let alert = UIAlertController(title: "Sorry, an error occurred", message: errorText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
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
        if tweets.count > indexPath.row,
            let url = URL(string: "https://twitter.com/anyuser/status/\(tweets[indexPath.row].id)"),
            UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TweetsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, text.count > 0 else { return }
        
        loadingView.startAnimating()
        tweetManager.getTweets(keyword: text) { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.loadingView.stopAnimating()
                
                switch result {
                case .success(let tweets):
                    strongSelf.updateTweets(tweets)
                    
                case .error(let errorText):
                    strongSelf.showError(errorText)
                }
            }
        }
    }
}
