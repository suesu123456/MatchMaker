//
//  ChatViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/8.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyBoardView: UIView!
    
    var contentArray: [[String]] = []
    var avaWidth: CGFloat = 50 //头像大小
    var friend: FriendsModel!
    var userid: Int = 0
    var username: String = ""
    var userava: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRecive()
        self.initData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.initViews()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initRecive() {
        Socket.sharedInstance.socket.on("receive_one") { (data, ack) -> Void in
            let json = JSON(data)
            //通知有消息
            self.showMsgInChat(json.arrayObject)
        }
    }
    func initData() {
       
        userid = UserModel.getUserInfo("userid") as! Int
        username = UserModel.getUserInfo("name") as! String
        userava = UserModel.getUserInfo("ava") as! String
        //先获取本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) , { [weak self]() -> Void in
            if let weakSelf = self {
                let result: [MessageModel] = SqlManage().getMessageById(weakSelf.friend.friendid, id: weakSelf.userid)
                for var model in result {
                    var arrayTemp: [String] = []
                    arrayTemp.append(model.fromusername)
                    arrayTemp.append(model.message)
                    weakSelf.contentArray.append(arrayTemp)
                }
                print(weakSelf.contentArray)
            }
            dispatch_async(dispatch_get_main_queue(), { [weak self]() -> Void in
                if let weakSelf = self {
                    if weakSelf.contentArray.count > 0 {
                        weakSelf.tableView.reloadData()
                        weakSelf.scrollToBottom()
                    }
                }
                })
            })
    }
    func scrollToBottom() {
        //滚动至底部
        if self.tableView.contentSize.height > self.tableView.frame.size.height{
            let offset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
            self.tableView.setContentOffset(offset, animated: false)
        }
    }
    func initViews() {
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
    }
    func saveMessage(curMsg: MessageModel) {
        //先获取本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) , { [weak self]() -> Void in
            if let weakSelf = self {
                SqlManage().saveMessage([curMsg])
            }
            dispatch_async(dispatch_get_main_queue(), { [weak self]() -> Void in
                if let weakSelf = self {
                    weakSelf.tableView.reloadData()
                    let msg: [String: AnyObject] = ["fromscId": Socket.sharedInstance.socketId,
                        "fromuserId": weakSelf.userid,
                        "fromuserName": weakSelf.username,
                        "touserId": weakSelf.friend.friendid,
                        "tousername": weakSelf.friend.friendname,
                        "msg": weakSelf.textView.text,
                        "time": curMsg.time
                    ]
                    Socket.sharedInstance.socket.emit("message", msg)
                    weakSelf.view.endEditing(true)
                    weakSelf.textView.text = ""

                }
            })
        })
    }
    func saveFriendsMessage(curMsg: [MessageModel]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) , { [weak self]() -> Void in
            if let weakSelf = self {
                SqlManage().saveMessage(curMsg)
            }
        })

    }
    //点击了发送消息
    @IBAction func sendMessage(sender: AnyObject) {
        //空的不发送
        if textView.text.isEmpty {
            return
        }
        var arrayTemp: [String] = []
        arrayTemp.append(username)
        arrayTemp.append(textView.text)
        self.contentArray.append(arrayTemp)
        let curMsg = MessageModel()
        curMsg.fromuserid = self.userid
        curMsg.fromusername = username
        curMsg.touserid = friend.friendid
        curMsg.tousername = friend.friendname
        curMsg.message = textView.text
        curMsg.time = DateHelper.getTimeMachine()
        curMsg.hasread = 1
        self.saveMessage(curMsg)
    }
    //泡泡文本
    func bubbleView(text: String, fromSelf: Bool, position: Int) -> UIView{
        
        let width: CGFloat = SCREEN_WIDTH - 20 - avaWidth //字体长度，左右边距10
        let size = text.sizeForStr(14, maxWidth: width)
        let returnView = UIView(frame: CGRectZero)
        returnView.backgroundColor = UIColor.clearColor()
        //图片
        let bubble: UIImage!
        if fromSelf {
            bubble = UIImage(named: "bubble")
        }else{
            bubble = UIImage(named: "bubble")
        }
        let bubbleImageView = UIImageView(image: bubble.stretchableImageWithLeftCapWidth(Int(bubble.size.width/CGFloat(2)), topCapHeight: Int(bubble.size.height/CGFloat(2))))
        //文本
        let bubbleText = UILabel(frame: CGRectMake(10, 20, size.width, size.height))
        bubbleText.backgroundColor = UIColor.clearColor()
        bubbleText.font = UIFont.systemFontOfSize(14)
        bubbleText.numberOfLines = 0
        bubbleText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        bubbleText.text = text
        
        bubbleImageView.frame = CGRectMake(0, 14, bubbleText.frame.size.width + 20 , bubbleText.frame.size.height + 20)
        if fromSelf {
            returnView.frame = CGRectMake(SCREEN_WIDTH - CGFloat(position) - bubbleText.frame.size.width, 0, bubbleText.frame.size.width , bubbleText.frame.size.height + 30)
        }else{
            returnView.frame = CGRectMake(CGFloat(position), 0, bubbleText.frame.size.width - 10, bubbleText.frame.size.height + 30)
        }
        returnView.addSubview(bubbleImageView)
        returnView.addSubview(bubbleText)
        return returnView
    }
    
    //TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contentArray.count > 0 {
            let text: [String] = contentArray[indexPath.row]
            return text[1].heightForStr(14, width: 300) + 44
        }else{
            return 44
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "chartCell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if contentArray.count > 0 {
            let text: [String] = contentArray[indexPath.row]
            //创建头像
            var photo: UIImageView!
            if contentArray[indexPath.row][0] == username {
                photo = UIImageView(frame: CGRectMake(SCREEN_WIDTH - avaWidth - 10, 10, avaWidth, avaWidth))
                photo.sd_setImageWithURL(NSURL(string: userava), placeholderImage: UIImage())
                cell?.addSubview(photo)
                cell?.addSubview(self.bubbleView(text[1], fromSelf: true, position: 65))
            }else{
                photo = UIImageView(frame: CGRectMake(10, 10, avaWidth, avaWidth))
                photo.sd_setImageWithURL(NSURL(string: self.friend.friendava), placeholderImage: UIImage())
                cell?.addSubview(photo)
                cell?.addSubview(self.bubbleView(text[1], fromSelf: false, position: 65))
            }
            
            photo.layer.masksToBounds = true
            photo.layer.cornerRadius = avaWidth / 2
        }
        return cell!
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    //keyboard
    func keyBoardWillShow(note: NSNotification) {
        let userInfo  = note.userInfo
        let  keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            self.keyBoardView.transform = CGAffineTransformMakeTranslation(0,-deltaY)
        }
        if duration > 0 {
            let options =  UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        self.scrollToBottom()
    }
    func keyBoardWillHide(note:NSNotification)
    {
        let userInfo  = note.userInfo
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.keyBoardView.transform = CGAffineTransformIdentity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        self.scrollToBottom()
    }
    func showMsgInChat(jsonArray: [AnyObject]?) {
        var flag = false
        var messages: [MessageModel] = []
        let array: [AnyObject] = jsonArray![0] as! [AnyObject]
        for obj in array {
            contentArray.append([obj["fromuserName"] as! String, obj["msg"] as! String])
            let json = JSON(obj)
            let msg: MessageModel = MessageModel()
            msg.fromuserid = json["fromuserId"].intValue
            msg.fromusername = json["fromuserName"].stringValue
            msg.touserid = json["touserId"].intValue
            msg.tousername = json["touserName"].stringValue
            msg.time = json["sendtime"].stringValue
            msg.message = json["msg"].stringValue
            msg.hasread = 1
            messages.append(msg)
            flag = true
        }
        if flag {
            self.tableView.reloadData()
            self.saveFriendsMessage(messages)
        }
    }
}
