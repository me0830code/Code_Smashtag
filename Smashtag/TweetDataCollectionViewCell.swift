//
//  TweetDataCollectionViewCell.swift
//  Smashtag
//
//  Created by Chien on 2017/8/3.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit
import Twitter

class TweetDataCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "TweetDataCollectionViewCell"

    @IBOutlet weak var labelContentWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageNext: UIImageView!
    @IBOutlet weak var imageUser: UIImageView! {
        didSet {
            self.imageUser.layer.cornerRadius = self.imageUser.frame.width / 2
            self.imageUser.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var labelAccount: UILabel!
    @IBOutlet weak var labelContent: UILabel!

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTime: UILabel!

    // MARK: Set Up Tweet Request Data
    func setUpWithRequestData(_ dataTweet: Tweet) {
        self.imageUser.image = nil
        if let userPhotoURL = dataTweet.user.profileImageURL {
            AppDelegate.cacheHelper.findImage(userPhotoURL) { (image) in
                self.imageUser.image = image
            }
        }

        let thingsShouldBeChangeColor: [([Mention], UIColor)] = [(dataTweet.hashtags, Constant.Color.hashTag),
                                                                 (dataTweet.urls, Constant.Color.url),
                                                                 (dataTweet.userMentions, Constant.Color.userMention)]

        self.labelContent.text = dataTweet.text
        self.labelContent.changeSpecificColor(thingsShouldBeChangeColor)

        self.labelAccount.text = "@\(dataTweet.user.screenName) (\(dataTweet.user.name))"

        let convertTime = Convert().dateToDayAndTime(with: dataTweet.created)
        self.labelDay.text = convertTime.Day
        self.labelTime.text = convertTime.Time
    }

    // MARK: Update Width Constraint For Dynamic Height
    func updateWidthConstraint(with width: CGFloat) {

        let largeMargin: CGFloat = 15.0
        let smallMargin: CGFloat = 5.0

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.labelContentWidthConstraint.constant = width - self.imageUser.frame.width - self.imageNext.frame.width - largeMargin * 2 - smallMargin * 2
    }
}
