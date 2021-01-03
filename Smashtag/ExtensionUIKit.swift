//
//  ExtensionUIKit.swift
//  Smashtag
//
//  Created by Chien on 2017/8/7.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit
import Twitter

extension UILabel {

    // MARK: For UILabel Change Different Color In One Text
    func changeSpecificColor(_ needChange: [(target: [Mention], color: UIColor)]) {
        guard let text = self.text else { return }
        let newAttribute = NSMutableAttributedString(string: text)

        for indexChange in 0 ..< needChange.count {
            let target = needChange[indexChange].target // 分別是 Hashtag、URL、UserMention
            let targetColor = needChange[indexChange].color // 各個所代表的顏色
            let targetCount = target.count

            for indexTarget in 0 ..< targetCount {
                newAttribute.addAttribute(NSForegroundColorAttributeName, value: targetColor, range: NSRange(location: target[indexTarget].nsrange.location, length: target[indexTarget].nsrange.length))
            }
        }

        self.attributedText = newAttribute
    }
}
