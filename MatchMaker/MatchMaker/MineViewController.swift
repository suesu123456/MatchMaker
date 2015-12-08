//
//  MineViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/6.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class MineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav()
        //self.view.backgroundColor = UIColor.blackColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        initHeader()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initNav(){
        self.title = "我的领地"
    
    }
    func initHeader() {
        let header = UIView(frame: CGRectMake(0,64,SCREEN_WIDTH, 100))
        header.backgroundColor = UIColor.blackColor()
        let ava = UIButton(frame: CGRectMake(SCREEN_WIDTH / 2 - 30, 24, 60, 60))
        ava.setImage(UIImage(named: "photo_sue"), forState: UIControlState.Normal)
        ava.addTarget(self, action: "lookProfile", forControlEvents: UIControlEvents.TouchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: "altAva")
        longPress.minimumPressDuration = 1 // 定义按的时间
        ava.addGestureRecognizer(longPress)
        ava.layer.masksToBounds = true
        ava.layer.cornerRadius = 30
        ava.contentMode = UIViewContentMode.ScaleAspectFill
        header.addSubview(ava)
        self.tableView.tableHeaderView = header
    }
    //个人资料
    func lookProfile() {
       let profile = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController")
        self.navigationController?.pushViewController(profile!, animated: true)
    }
    //修改头像
    func altAva() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "从相册选取",otherButtonTitles: "拍照")
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque;
        actionSheet.showInView(self.view)
        
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            // 打开相册
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
    }
    // 当选择一张图片后进入这里
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let type: String = info[UIImagePickerControllerMediaType]as! String
        if type == "public.image" {
            //修改头像
            //1.将图片转为nsdata
            let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            var data: NSData
            data = UIImageJPEGRepresentation(image, 0.8)!
           
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func present(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MineCell? = tableView.dequeueReusableCellWithIdentifier("mineCell") as? MineCell
        if cell == nil {
            cell = MineCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mineCell")
        }
        cell!.setData()
        return cell!
    }
    
    
}
