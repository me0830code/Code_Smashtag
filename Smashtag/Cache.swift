//
//  Cache.swift
//  Smashtag
//
//  Created by Chien on 2017/7/18.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit

class Cache {

    fileprivate let cacheBox: NSCache = NSCache<NSString, AnyObject>()

    // MARK: - Find Image In Cache Or Get URL Request
    func findImage(_ url: URL, completionHandler: @escaping (_ image: UIImage) -> ()) {
        if let image = self.cacheBox.object(forKey: url.absoluteString as NSString) as? UIImage {
            DispatchQueue.main.async {
                completionHandler(image) // 有在 Cache 裡，就直接拿來用
            }
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else {
                    print("Error fetch data from url")
                    return
                }

                guard let image = UIImage(data: data) else {
                    print("Error fetch image from data")
                    return
                }

                self.cacheBox.setObject(image, forKey: url.absoluteString as NSString)

                DispatchQueue.main.async {
                    completionHandler(image) // 沒有在 Cache 裡，就發 Request 去拿再回來存回 Cache
                }
            }
        }
    }
}
