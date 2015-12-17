//
//  UserModel.swift
//  MatchMaker
//
//  Created by sue on 15/12/16.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserModel: NSObject {
    //保存用户信息到本地
    static func saveUserData(dict: JSON) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dict as? AnyObject, forKey: "user_info")
        defaults.synchronize()
    }
    //获取用户登陆状态
    static func isLogin() -> Bool {
        if NSUserDefaults.standardUserDefaults().objectForKey("user_info") != nil{
            let loginData : [String: AnyObject] = NSUserDefaults.standardUserDefaults().objectForKey("user_info") as! [String: AnyObject]
            if !loginData.isEmpty {
                return true
            }
        }
        return false
    }
    //返回用户特定信息
    static func getUserInfo(field: String) -> AnyObject {
        if NSUserDefaults.standardUserDefaults().objectForKey("user_info") != nil{
            let loginData : [String: AnyObject] = NSUserDefaults.standardUserDefaults().objectForKey("user_info") as! [String: AnyObject]
            if !loginData.isEmpty {
                return loginData[field]!
            }
        }
        return -1
    }
}
