//
//  MineViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/6.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class MineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH, 180))
        header.backgroundColor = UIColor.blackColor()
        let ava = UIButton(frame: CGRectMake(SCREEN_WIDTH / 2 - 30, 64, 60, 60))
        ava.setImage(UIImage(named: "photo_sue"), forState: UIControlState.Normal)
        ava.layer.masksToBounds = true
        ava.layer.cornerRadius = 30
        ava.contentMode = UIViewContentMode.ScaleAspectFill
        header.addSubview(ava)
        return header
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("mineCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mineCell")
        }
        cell!.textLabel?.text = "123"
        return cell!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
