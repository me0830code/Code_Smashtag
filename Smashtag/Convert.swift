//
//  Convert.swift
//  Smashtag
//
//  Created by Chien on 2017/8/22.
//  Copyright © 2017年 Chien. All rights reserved.
//

import Foundation

class Convert {

    // MARK: Convert Time To AM / PM
    func dateToDayAndTime(with createdDate: Date) -> (Day: String?, Time: String?) {
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        formatter.dateFormat = "yyyy.MM.dd" // Get 2017.06.30
        let day = formatter.string(from: createdDate)

        formatter.dateFormat = "HH:mm a" // Get 15:40 PM
        let time = formatter.string(from: createdDate)

        return (day, time)
    }
}
