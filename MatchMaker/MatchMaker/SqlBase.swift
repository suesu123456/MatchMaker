//
//  SqlBase.swift
//  MatchMaker
//
//  Created by sue on 16/1/3.
//  Copyright © 2016年 sue. All rights reserved.
//

import UIKit

class SqlBase: NSObject {
    class var sharedInstance : SqlBase {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : SqlBase? = nil
            
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SqlBase()
        }
        return Static.instance!
    }
    
    var path: String!
    var db: FMDatabase!
    var queue: FMDatabaseQueue!
    func createDatabase() {
        var pa: [AnyObject] = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let document: String = pa[0] as! String
        path = (document as NSString).stringByAppendingPathComponent("MatchMaker.sqlite")
        if db == nil {
            db = FMDatabase(path: path)
            queue = FMDatabaseQueue(path: path)
        }
    }
    
    func createTable(sql: String, table: String) {
        if db == nil {
            self.createDatabase()
        }
        queue.inDatabase { (db) -> Void in
            db.open()
            db.setShouldCacheStatements(true)
            if (!db.tableExists(table)) {
                db.executeStatements(sql)
            }
            db.close()
        }
    }
    //删除表中所有数据
    func deleteAllDataById(sql: String, array: [AnyObject]) {
        queue.inDatabase { (db) -> Void in
            db.open()
            db.executeUpdate(sql, withArgumentsInArray: array)
            db.close()
        }
    }
    func insertAll(sql: String) {
        queue.inDatabase { (db) -> Void in
            db.open()
            db.executeStatements(sql)
            db.close()
        }
    }
    func insert(model: [AnyObject], sql: String) {
        queue.inDatabase { (db) -> Void in
            db.open()
            db.executeUpdate(sql, withArgumentsInArray: model)
            db.close()
        }
    }
    func update(sql: String, model: [AnyObject]) {
        queue.inDatabase { (db) -> Void in
            db.open()
            db.executeUpdate(sql, withArgumentsInArray: model)
            db.close()
        }
    }
    func selectFromMessage(para: [AnyObject], sql: String) -> [MessageModel] {
        var resultArray: [MessageModel] = []
        queue.inDatabase { (db) -> Void in
            db.open()
            let rs = db.executeQuery(sql, withArgumentsInArray: para)
            if rs != nil{
                while rs.next() {
                    let model: MessageModel = MessageModel()
                    model.fromuserid = Int(rs.intForColumn("fromuserid"))
                    model.fromusername = rs.stringForColumn("fromusername")
                    model.touserid = Int(rs.intForColumn("touserid"))
                    model.tousername = rs.stringForColumn("tousername")
                    model.hasread = Int(rs.intForColumn("hasread"))
                    model.message = rs.stringForColumn("message")
                    model.time = rs.stringForColumn("time")
                    resultArray.append(model)
                }
            }
            db.close()
        }
        return resultArray
    }
    func selectFromFriends(para: [AnyObject], sql: String) -> [FriendsModel] {
        var resultArray: [FriendsModel] = []
        queue.inDatabase { (db) -> Void in
            db.open()
            let rs = db.executeQuery(sql, withArgumentsInArray: para)
            if rs != nil{
                while rs.next() {
                    let model: FriendsModel = FriendsModel()
                    model.userid = Int(rs.intForColumn("userid"))
                    model.friendid = Int(rs.intForColumn("friendid"))
                    model.friendname = rs.stringForColumn("friendname")
                    model.friendava = rs.stringForColumn("friendava")
                    model.friendsex = Int(rs.intForColumn("friendsex"))
                    //获取该好友的未读消息条数
                    let sql2 = "select COUNT(*) from MESSAGE where fromuserid = ? and touserid = ?"
                    let rs2 = db.executeQuery(sql2, withArgumentsInArray: [NSNumber(integer: model.friendid), NSNumber(integer: model.userid)])
                    if rs2.next() {
                        model.hasMsg = Int(rs2.intForColumnIndex(0))
                    }
                    resultArray.append(model)
                    
                }
            }
            db.close()
        }
        return resultArray
    }


}
