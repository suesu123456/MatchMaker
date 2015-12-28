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
    static func saveUserData(dict:JSON) {
        let EncodedObject = NSKeyedArchiver.archivedDataWithRootObject(dict.dictionaryObject!)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(EncodedObject, forKey: "user_info")
        defaults.synchronize()
    }
    //获取用户登陆状态
    static func isLogin() -> Bool {
        if NSUserDefaults.standardUserDefaults().objectForKey("user_info") != nil{
            let loginData : NSData = NSUserDefaults.standardUserDefaults().objectForKey("user_info") as! NSData
            if loginData.length > 0  {
                return true
            }
        }
        return false
    }
    //返回用户特定信息
    static func getUserInfo(field: String) -> AnyObject {
        if NSUserDefaults.standardUserDefaults().objectForKey("user_info") != nil{
            let loginData : NSData = NSUserDefaults.standardUserDefaults().objectForKey("user_info") as! NSData
            
            if loginData.length > 0 {
                let user = NSKeyedUnarchiver.unarchiveObjectWithData(loginData) as!  [String : AnyObject]
                return user[field]!
            }
        }
        return -1
    }
    //将socketid存进本地
    static func saveSocketId(id: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(id, forKey: "socket_id")
        defaults.synchronize()
    }
    //获取socketid
    static func getSocketId() -> String {
        if NSUserDefaults.standardUserDefaults().objectForKey("socket_id") != nil{
            let id : String = NSUserDefaults.standardUserDefaults().objectForKey("socket_id") as! String
            if !id.isEmpty {
                return id
            }
        }
        return ""
    }

}
