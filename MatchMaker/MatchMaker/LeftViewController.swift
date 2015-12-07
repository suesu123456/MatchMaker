//
//  LeftViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/5.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var titleArray: [String] = ["123","123","123","我的领地"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("leftCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "leftCell")
        }
        cell?.contentView.backgroundColor = UIColor.blackColor()
        cell!.textLabel?.text = titleArray[indexPath.row]
        cell?.textLabel?.textColor = UIColor.whiteColor()
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            let mine = self.storyboard?.instantiateViewControllerWithIdentifier("MineViewController") as! MineViewController
            self.presentViewController(mine, animated: true, completion: nil)
        }
    }

}
