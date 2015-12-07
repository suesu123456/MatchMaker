//
//  HomeViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/5.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showLeft(sender: AnyObject) {
        self.presentLeftMenuViewController(self)
        
    }

 
}
