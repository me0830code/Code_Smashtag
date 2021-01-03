//
//  ImageDataCollectionViewCell.swift
//  Smashtag
//
//  Created by Chien on 2017/8/3.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit
import Twitter

class ImageDataCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "ImageDataCollectionViewCell"

    @IBOutlet weak var imagePosting: UIImageView!

    // MARK: Set Up Image Request Data 
    func setUpWithRequestData(_ dataImage: (index: Int, url: URL)) {
        self.imagePosting.image = nil
        let postingURL = dataImage.url
        AppDelegate.cacheHelper.findImage(postingURL) { (image) in
            self.imagePosting.image = image
            self.imagePosting.contentMode = .scaleAspectFill
        }
    }
}
