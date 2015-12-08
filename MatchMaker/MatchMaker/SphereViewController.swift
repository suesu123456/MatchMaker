//
//  SphereViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/8.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class SphereViewController: UIViewController {

    var sphereView: DBSphereView!
    var patchView: SFPatchView!
    var person: [[AnyObject]] = [["sue", UIImage(named: "photo_sue")!],
        ["peach", UIImage(named: "photo_peach")!],
        ["k_seven", UIImage(named: "photo_seven")!]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "连线吧"
        self.initViews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViews() {
        sphereView = DBSphereView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        let array = NSMutableArray(capacity: 0)
        for var i = 0; i < person.count; i++ {
            let btn: UIButton = UIButton(type: UIButtonType.System)
            btn.setTitle(person[i][0] as! String, forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0 , bottom: 50, right: 0)
            btn.layer.masksToBounds = true
            btn.setBackgroundImage(person[i][1] as! UIImage, forState: UIControlState.Normal)
            btn.contentMode = UIViewContentMode.ScaleAspectFit
            btn.frame = CGRectMake(0, 0, 60, 60)
            btn.layer.cornerRadius = 30
            btn.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
            array.addObject(btn)
            sphereView.addSubview(btn)
        }
        sphereView.setCloudTags(array as [AnyObject])
        sphereView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(sphereView)
    }
    
    func buttonPressed(btn: UIButton) {
        sphereView.timerStop()
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.patchView = SFPatchView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64))
            //self.patchView.backgroundColor = UIColor.blackColor()
            self.patchView.setBtn(btn, array: ["photo_peach", "photo_seven","photo_peach", "photo_seven","photo_peach", "photo_seven"])
            self.view.addSubview(self.patchView)
            }) { (flag) -> Void in
                
        }
        

    }

}
