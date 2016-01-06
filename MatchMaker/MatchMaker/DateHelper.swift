//
//  DateHelper.swift
//  MatchMaker
//
//  Created by sue on 16/1/5.
//  Copyright © 2016年 sue. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
    //获取现在时间戳
    static func getTimeMachine() -> String {
        let date = NSDate(timeIntervalSinceNow: 0)
        let ter = date.timeIntervalSince1970 * 1000
        return String(ter)
    }

}
