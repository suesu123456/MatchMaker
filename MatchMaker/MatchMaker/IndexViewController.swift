//
//  LeftViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/5.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

protocol menuDelegate {
    func showMenu()
}

class IndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var delegate: menuDelegate?
    var titleArray: [String] = ["Boys", "Girls"]
    var resultArray: [[FriendsModel]] = []
    var userid: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userid = UserModel.getUserInfo("userid") as! Int
        initData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        //注册一个通知，用于列表时得消息提醒
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMsgInTable:", name: "showMsgInTable", object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initData() {
        //先获取本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) , { [weak self]() -> Void in
            if let weakSelf = self {
                if weakSelf.resultArray.count == 0 {
                    weakSelf.resultArray = [[],[]]
                    let result: [FriendsModel] = SqlManage().getFriends(weakSelf.userid)
                    for var model in result {
                        if model.friendsex == 0 { //男生
                            weakSelf.resultArray[0].append(model)
                        }else{
                            weakSelf.resultArray[1].append(model)
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { [weak self]() -> Void in
                if let weakSelf = self {
                    if weakSelf.resultArray.count > 0 {
                        weakSelf.tableView.reloadData()
                    }
                    weakSelf.netWork()
                }
                })
            })
    }
    func netWork() {
        let para = ["id": 1]
        NetBase.postByUser(para, url: NetUrl.getFriends).then{ [weak self](json) -> Void in
            if let weakSelf = self {
                if json.arrayObject?.count > 0 {
                    var resultTemp: [[FriendsModel]] = [[],[]]
                    var friends: [FriendsModel] = []
                    for (index, subJson): (String, JSON) in json {
                        let model = FriendsModel().initFriends(subJson.dictionaryObject)
                        
                        if model.friendsex == 0 { //男生
                             resultTemp[0].append(model)
                        }else{
                             resultTemp[1].append(model)
                        }
                        friends.append(model)
                    }
                    if resultTemp != weakSelf.resultArray {
                        weakSelf.resultArray = resultTemp
                        weakSelf.tableView.reloadData()
                        SqlManage().updateFriends(friends, id: weakSelf.userid)
                    }
                   
                }
                weakSelf.initRecive()
            }
        }.error { (error) -> Void in
            print(error)
        }
    }
   
    @IBAction func showMenu(sender: AnyObject) {
        self.delegate?.showMenu()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titleArray.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleArray[section]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count <= 0 ? 0 : resultArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: IndexCell! = tableView.dequeueReusableCellWithIdentifier("indexCell") as? IndexCell
        if cell == nil {
            cell = IndexCell(style: UITableViewCellStyle.Default, reuseIdentifier: "indexCell")
        }
        
        if resultArray[indexPath.section].count > 0 {
            
            let json: FriendsModel = resultArray[indexPath.section][indexPath.row]
            cell.avaImage?.sd_setImageWithURL(NSURL(string: json.friendava), placeholderImage: UIImage(named: "photo_sue"))
            cell.titleLabel?.text = json.friendname
            cell.hasMessage?.setTitle(json.hasMsg > 0 ? String(json.hasMsg) : "", forState: .Normal)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mine = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        mine.friend = self.resultArray[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(mine, animated: true)
    }
    func initRecive() {
        Socket.sharedInstance.socket.on("receive") { (data, ack) -> Void in
            let json = JSON(data)
            //通知有消息
            self.showMsgInTable(json.arrayObject)
        }
    }
    //处理消息提醒
    func showMsgInTable(jsonArray: [AnyObject]?) {
        //将消息存进数据库
        var messages: [MessageModel] = []
        let array: [AnyObject] = jsonArray![0] as! [AnyObject]
        for obj in array{
            let json = JSON(obj)
            let msg: MessageModel = MessageModel()
            msg.fromuserid = json["fromuserId"].intValue
            msg.fromusername = json["fromuserName"].stringValue
            msg.touserid = json["touserId"].intValue
            msg.tousername = json["touserName"].stringValue
            msg.time = json["sendtime"].stringValue
            msg.message = json["msg"].stringValue
            msg.hasread = 0
            messages.append(msg)
        }
        SqlManage().saveMessage(messages)
        
//        var flag = false
//        let json = ns.object as? [AnyObject]
//        let jsonArray = json![0] as? [AnyObject]
//        for obj in jsonArray! {
//            var k = 0
//            for var obj2 in self.resultArray {
//                for var i = 0; i < obj2.count; i++ {
//                    print(obj)
//                    if String(obj2[i].friendid) == obj["fromuserId"] as! String {
//                        self.resultArray[k][i].hasMsg = self.resultArray[k][i].hasMsg + 1
//                        flag = true
//                    }
//                }
//                k++
//            }
//        }
//        if flag {
//            self.tableView.reloadData()
//          
//            
//            
//            
//            
//            
//            
//            
//            
//        }
    }

}
