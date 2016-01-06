//
//  SqlManage.swift
//  MatchMaker
//
//  Created by sue on 16/1/3.
//  Copyright © 2016年 sue. All rights reserved.
//

import UIKit

class SqlManage: NSObject {
    //创建好友列表
    func createFriendsTable() {
        SqlBase.sharedInstance.createDatabase()
        let sql = "CREATE TABLE IF NOT EXISTS FRIENDS (userid Integer,friendid Integer,friendname Text,friendava Text,friendsex Integer)"
        SqlBase.sharedInstance.createTable(sql, table:"FRIENDS")
    }
    //创建消息表
    func createMessageTable() {
        SqlBase.sharedInstance.createDatabase()
        let sql = "CREATE TABLE IF NOT EXISTS MESSAGE (fromuserid Integer,fromusername Text,touserid Integer,tousername Text,hasread Integer,message Text,time Text)"
        SqlBase.sharedInstance.createTable(sql, table:"MESSAGE")
    }
    //保存最新数据
    func updateFriends(model : [FriendsModel], id: Int) {
        SqlBase.sharedInstance.createDatabase()
        self.createFriendsTable()
        let sql = "DELETE FROM FRIENDS"
        SqlBase.sharedInstance.deleteAllDataById(sql, array: [NSNumber(integer: id)])
        var query: String = ""
        for mm in model {
            let id = NSNumber(integer: mm.userid)
            let friendid = NSNumber(integer: mm.friendid)
            let friendsex = NSNumber(integer: mm.friendsex)
            let queryStr:String = ("(\(id),'\(friendid)','\(mm.friendname)','\(mm.friendava)','\(friendsex)'),")
            query += queryStr
        }
        query.removeAtIndex(query.endIndex.predecessor())
        let sql2 = "INSERT INTO FRIENDS (userid ,friendid ,friendname ,friendava ,friendsex ) VALUES "+query
        SqlBase.sharedInstance.insertAll(sql2)
    }
    //获取好友列表
    func getFriends(id: Int) -> [FriendsModel] {
        self.createFriendsTable()
        let sql = "select * from FRIENDS where userid = ?"
        let result: [FriendsModel] = SqlBase.sharedInstance.selectFromFriends([NSNumber(integer: id)], sql: sql)
        return result
    }
    //获取未读消息
    func getUnreadMsg(id: Int) -> [MessageModel] {
        self.createMessageTable()
        let sql = "select * from MESSAGE where hasread = ? and touserid = ?"
        let result: [MessageModel] = SqlBase.sharedInstance.selectFromMessage([0, NSNumber(integer: id)], sql: sql)
        return result
    }
    //存消息
    func saveMessage(model: [MessageModel]) {
        self.createMessageTable()
        var query: String = ""
        for mm in model {
            let id = NSNumber(integer: mm.fromuserid)
            let toid = NSNumber(integer: mm.touserid)
            let read = NSNumber(integer: mm.hasread)
            let queryStr:String = ("(\(id),'\(mm.fromusername)',\(toid),'\(mm.tousername)',\(read),'\(mm.message)', '\(mm.time)'),")
            query += queryStr
        }
        query.removeAtIndex(query.endIndex.predecessor())
        let sql2 = "INSERT INTO MESSAGE (fromuserid ,fromusername ,touserid ,tousername ,hasread ,message ,time ) VALUES "+query
        SqlBase.sharedInstance.insertAll(sql2)
    }
    //获取消息
    func getMessageById(friendid: Int, id: Int) -> [MessageModel] {
        self.createMessageTable()
        let sql = "select * from MESSAGE where (fromuserid = ? and touserid = ?) or (fromuserid = ? and touserid = ?) order by time ASC"
        let result: [MessageModel] = SqlBase.sharedInstance.selectFromMessage([NSNumber(integer: id), NSNumber(integer: friendid),NSNumber(integer: friendid), NSNumber(integer: id)], sql: sql)
        return result
    }
}
