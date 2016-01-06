//
//  FriendsModel.swift
//  MatchMaker
//
//  Created by sue on 16/1/3.
//  Copyright © 2016年 sue. All rights reserved.
//

import UIKit
import ObjectMapper

class FriendsModel {
    
    var userid: Int = 1
    var friendid: Int = 1
    var friendname: String = ""
    var friendava: String = ""
    var friendsex: Int = 0
    var hasMsg: Int = 0
    
    func initFriends(json: [String: AnyObject]?) -> FriendsModel {
        self.userid = UserModel.getUserInfo("userid") as! Int
        self.friendid = json!["userid"] as! Int
        self.friendname = json!["name"] as! String
        self.friendava = json!["ava"] as! String
        self.friendsex = json!["sex"] as! Int
        return self
    }
}
