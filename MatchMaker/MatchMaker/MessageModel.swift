//
//  MessageModel.swift
//  MatchMaker
//
//  Created by sue on 16/1/3.
//  Copyright © 2016年 sue. All rights reserved.
//

import UIKit

class MessageModel: NSObject {
    var messageid: Int = 0
    var fromuserid: Int = 1
    var fromusername: String = ""
    var touserid: Int = 1
    var tousername: String = ""
    var message: String = ""
    var hasread: Int = 0 // 默认0是未读消息
    var time: String = "" //时间
}
