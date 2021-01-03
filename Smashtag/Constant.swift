//
//  Constant.swift
//  Smashtag
//
//  Created by Chien on 2017/6/30.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit

struct Constant {

    struct Color {
        static let hashTag: UIColor = UIColor(red: 231/255, green: 0/255, blue: 0/255, alpha: 1)
        static let url: UIColor = UIColor(red: 133/255, green: 200/255, blue: 221/255, alpha: 1)
        static let userMention: UIColor = UIColor(red: 0/255, green: 170/255, blue: 160/255, alpha: 1)
    }

    struct Title {
        static let searchPage: String = "搜尋標籤"
        static let recentPage: String = "歷史搜尋"
    }

    struct Font {
        static let helveticaBold: UIFont! = UIFont(name: "Helvetica-Bold", size: 20)
    }

    struct Search {
        static let howManyItems: Int = 50
    }
}
