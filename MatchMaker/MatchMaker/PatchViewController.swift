//
//  PatchViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/8.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class PatchViewController: UIViewController, CloudViewDelegate {

    var person: [[AnyObject]] = [["sue", UIImage(named: "photo_sue")!],
        ["peach", UIImage(named: "photo_peach")!],
        ["k_seven", UIImage(named: "photo_seven")!]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        let cloud = CloudView(frame: self.view.bounds, andNodeCount:  3, andPersonArray:  person)
        cloud.delegate = self
        self.view.addSubview(cloud)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didSelectedNodeButton(button: CloudButton!) {
        print(button.tag)
    }

}
