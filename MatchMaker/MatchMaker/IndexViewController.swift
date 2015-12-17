//
//  LeftViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/5.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol menuDelegate {
    func showMenu()
}

class IndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var delegate: menuDelegate?
    var titleArray: [[String:[JSON]]] = [["Boys":[]],[["Girls": []]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initData() {
        let para = ["id": 1]
        NetBase.postByUser(para, url: NetUrl.getFriends).then{ (json) -> Void in
            for (index, subJson): (String, JSON) in json {
                if subJson["sex"] == 0 { //男生
                    self.titleArray[0].append(subJson)
                }else{
                    self.titleArray[1].append(subJson)
                }
            }
           
            //将取回的数据男女分类
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
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("indexCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "indexCell")
        }
        cell?.imageView?.image = UIImage(named: "photo_sue")
        cell?.imageView?.layer.masksToBounds = true
        cell?.imageView?.layer.cornerRadius = (cell?.imageView?.frame.width)! / 2
        cell!.textLabel?.text = "sue"//titleArray[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mine = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(mine, animated: true)
        
    }

}
