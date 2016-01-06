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
    }
    override func viewDidAppear(animated: Bool) {
        if !UserModel.isLogin() {
            let login = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(login, animated: true, completion: nil)
        }
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
        let item4 = MediumMenuItem(title: "注销") { () -> Void in
            UserModel.logout()
            let login = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(login, animated: true, completion: nil)
        }
        menu = MediumMenu(items: [item1, item2, item3, item4], forViewController: self)
        menu?.titleFont = UIFont(name: "AvenirNext-Regular", size: 18)
        menu?.height = 300
        menu?.velocityTreshold = 300
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
