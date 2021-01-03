//
//  BasicViewController.swift
//  Smashtag
//
//  Created by Chien on 2017/8/3.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit
import Twitter

class BasicViewController: UIViewController {

    // MARK: Get Search Tag Request
    func getSearchRequest(with tag: String, num: Int) -> Request {
        return Request.init(search: tag, count: num)
    }

    // MARK: Get Request Data ( tweetRequest maybe is Normal、Older、Newer )
    func getRequestData(use tweetRequest: Request?, nowTweetCount: Int, completionHandler: @escaping (_ fetchTweets: [Tweet], _ fetchImages: [(index: Int, url: URL)]) -> ()) {

        self.navigationItem.title = tweetRequest?.searchTerm

        if tweetRequest == nil {
            completionHandler([], [])
        }

        self.view.isUserInteractionEnabled = false
        let indicator = Indicator()
        indicator.startAnimating()

        tweetRequest?.fetchTweets { (allTweets) in

            DispatchQueue.main.async {
                indicator.stopAnimating() // 用完即丟，不佔空間
                self.view.isUserInteractionEnabled = true
                completionHandler(allTweets, self.tweetsHaveImages(from: allTweets, tweetCount: nowTweetCount))
            }
        }
    }
    
    // MARK: Get All Images From All Tweets
    fileprivate func tweetsHaveImages(from allTweets: [Tweet], tweetCount: Int) -> [(index: Int, url: URL)] {
        var allImages: [(index: Int, url: URL)] = []

        for indexTweet in 0 ..< allTweets.count {
            for indexImage in 0 ..< allTweets[indexTweet].media.count {

                // 可能同個 tweet 裡面有一張以上的圖片，但是點進去後仍要顯示同一個 tweet。用這個 tuple 去抓住個別 url 對應的 indexOfTweet
                // 因爲 dataSource 是累加，所以加上 tweetCount (原先 tweetShowing 裡的數量) 才是真正的 index 位置
                allImages.append((index: indexTweet + tweetCount, url: allTweets[indexTweet].media[indexImage].url))
            }
        }

        return allImages
    }
}
