//
//  HomeViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/5.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import MediumMenu


class HomeViewController: UINavigationController, menuDelegate {

    var menu: MediumMenu?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMenu()
        self.setDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initMenu() {
        let item1 = MediumMenuItem(title: "我的好友") { () -> Void in
            let index = self.storyboard?.instantiateViewControllerWithIdentifier("IndexViewController") as! IndexViewController
            index.delegate = self
            self.setViewControllers([index], animated: true)
        }
        let item2 = MediumMenuItem(title: "连线吧") { () -> Void in
            let sphere = SphereViewController()
            self.setViewControllers([sphere], animated: true)
        }
        let item3 = MediumMenuItem(title: "我的领地") { () -> Void in
            let mine = self.storyboard?.instantiateViewControllerWithIdentifier("MineViewController") as! MineViewController
            self.setViewControllers([mine], animated: true)
        }
        menu = MediumMenu(items: [item1, item2, item3], forViewController: self)
        menu?.titleFont = UIFont(name: "AvenirNext-Regular", size: 18)
        menu?.height = 250
        menu?.velocityTreshold = 250
        menu?.heightForRowAtIndexPath = 50
        menu?.panGestureEnable = true
        menu?.highlighedIndex = 0
    }
    func setDelegate() {
        let index = self.viewControllers[0] as! IndexViewController
        index.delegate = self
    }
    func showMenu() {
        menu?.show()
    }
}
