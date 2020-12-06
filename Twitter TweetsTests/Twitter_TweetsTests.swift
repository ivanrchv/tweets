//
//  Twitter_TweetsTests.swift
//  Twitter TweetsTests
//
//  Created by Ivan Raychev on 4.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import XCTest
@testable import Twitter_Tweets

class Twitter_TweetsTests: XCTestCase {
    
    private var fetcher: TweetFetching!
    private var manager: TweetManager!
    
    override func setUp() {
        super.setUp()
        
        fetcher = MockTweetFetcher()
        manager = TweetManager(fetcher: fetcher)
    }
    
    func testStandart() {
        getTweets(configuration: .standart) { (result) in
            guard case .success(let tweets) = result else {
                XCTFail("getTweets not succesful")
                return
            }
            XCTAssertEqual(tweets.count, 3)
        }
    }
    
    func testEmptyDict() {
        getTweets(configuration: .emptyDict) { (result) in
            XCTAssertEqual(result, TweetResult.error("bad json"))
        }
    }
    
    func testEmptyArray() {
        getTweets(configuration: .dictWithEmptyArray) { (result) in
            XCTAssertEqual(result, TweetResult.success([]))
        }
    }
    
    func testInvalidTweets() {
        getTweets(configuration: .dictWithEmptyArray) { (result) in
            XCTAssertEqual(result, TweetResult.success([]))
        }
    }
    
    func testFetchingError() {
        getTweets(configuration: .fetchingError) { (result) in
            XCTAssertEqual(result, TweetResult.error("fetching error"))
        }
    }
    
    func getTweets(configuration: MockTweetFetcher.Configuration, completion: @escaping (TweetResult) -> Void) {
        manager.getTweets(keyword: configuration.rawValue, completion: completion)
    }
}
