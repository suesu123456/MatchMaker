//
//  ChatViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/8.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyBoardView: UIView!
    var contentArray = [["peach","你好"],["sue","我"],["peach","你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？"],["peach","helloskfksdhfjksdhfjksdhfjkdshfjkdh"],["peach","你好"],["sue","我"],["peach","你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？你好吗？"],["peach","helloskfksdhfjksdhfjksdhfjkdshfjkdh"]]
    var avaWidth: CGFloat = 50 //头像大小
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.initViews()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViews() {
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
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
        let text: [String] = contentArray[indexPath.row]
        return text[1].heightForStr(14, width: 300) + 44
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "chartCell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        let text: [String] = contentArray[indexPath.row]
        //创建头像
        var photo: UIImageView!
        if contentArray[indexPath.row][0] == "sue" {
            photo = UIImageView(frame: CGRectMake(SCREEN_WIDTH - avaWidth - 10, 10, avaWidth, avaWidth))
            cell?.addSubview(photo)
            photo.image = UIImage(named: "photo_sue")
            cell?.addSubview(self.bubbleView(text[1], fromSelf: true, position: 65))
        }else{
            photo = UIImageView(frame: CGRectMake(10, 10, avaWidth, avaWidth))
            cell?.addSubview(photo)
            photo.image = UIImage(named: "photo_peach")
            cell?.addSubview(self.bubbleView(text[1], fromSelf: false, position: 65))
        }
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = avaWidth / 2
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
           // self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height), animated: true)
        }
        if duration > 0 {
            let options =  UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
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
    }
}
