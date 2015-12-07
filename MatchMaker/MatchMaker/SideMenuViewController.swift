//
//  SideMenuViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/5.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    var leftMenuViewController: UIViewController?
    var rightMenuViewController: UIViewController?
    var contentViewController: UIViewController?
    
    
    var backgroundImageView: UIImageView!
    var menuViewContainer: UIView!
    var contentViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        initViews()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViews() {
        self.backgroundImageView = UIImageView(frame: self.view.bounds)
        self.backgroundImageView.image = UIImage(named: "")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(self.backgroundImageView)
        
        menuViewContainer = UIView(frame: self.view.bounds)
        self.view.addSubview(menuViewContainer)
        
        contentViewContainer = UIView(frame: self.view.bounds)
        self.view.addSubview(contentViewContainer)
        
        if self.leftMenuViewController != nil {
            self.addChildViewController(leftMenuViewController!)
            self.leftMenuViewController!.view.frame = self.view.bounds
            self.menuViewContainer.addSubview(self.leftMenuViewController!.view)
            self.leftMenuViewController?.didMoveToParentViewController(self)
        }
        if self.rightMenuViewController != nil {
            self.addChildViewController(rightMenuViewController!)
            self.rightMenuViewController!.view.frame = self.view.bounds
            self.menuViewContainer.addSubview(self.rightMenuViewController!.view)
            self.rightMenuViewController?.didMoveToParentViewController(self)
        }
        
        self.addChildViewController(contentViewController!)
        contentViewController?.view.frame = self.view.bounds
        self.contentViewContainer.addSubview((contentViewController?.view)!)
        self.contentViewController?.didMoveToParentViewController(self)
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
