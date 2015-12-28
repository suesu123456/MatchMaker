//
//  LoginViewController.swift
//  MatchMaker
//
//  Created by sue on 15/12/10.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import AVFoundation
import JGProgressHUD


enum currentStatus {
    case freeStatus
    case loginStatus
    case signupStatus
}
class LoginViewController: UIViewController {

    var status: currentStatus = .freeStatus
    
    var player: AVPlayer!
    var cardView: CardView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var regBtn: UIButton!
    
    var hud: JGProgressHUD = JGProgressHUD(style: .ExtraLight)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
       // self.createVideoPlayer()
        self.createShowAnim()
        self.addCardView()
        //键盘弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification ,object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initViews() {
        setBorder(self.loginBtn)
        setBorder(self.regBtn)
    }
    func setBorder(btn: UIButton) {
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.whiteColor().CGColor
        btn.layer.borderWidth = 1
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.clearColor()
    }
    func createVideoPlayer() {
        let filePath: String = NSBundle.mainBundle().pathForResource("welcome_video", ofType: "mp4")!
        let url: NSURL = NSURL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(URL: url)
        //playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        
        self.player = AVPlayer(playerItem: playerItem)
        self.player.volume = 0
        
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.frame = self.playerView.layer.bounds
        self.playerView.layer.addSublayer(playerLayer)
        
        self.player.play()
        
        self.player.currentItem?.addObserver(self, forKeyPath: AVPlayerItemDidPlayToEndTimeNotification, options: NSKeyValueObservingOptions.New,context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlayDidEnd"), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
    }
    //循环播放
    func moviePlayDidEnd(notification: NSNotification) {
        let item = notification.object
        item?.seekToTime(kCMTimeZero)
        self.player.play()
    }
    //动画
    func createShowAnim() {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.duration = 3.0
        self.loginBtn.layer.addAnimation(anim, forKey: "alpha")
        self.regBtn.layer.addAnimation(anim, forKey: "alpha")
        
        let keyAnim = CAKeyframeAnimation(keyPath: "opacity")
        keyAnim.duration = 5.0
        keyAnim.values = [0, 1, 0]
        keyAnim.keyTimes = [0, 0.35, 1.0]
        self.titleLabel.layer.addAnimation(keyAnim, forKey: "opacity")
        
    }
    func addCardView() {
        self.cardView = CardView()
        self.cardView.center = CGPointMake(CGRectGetMidX(self.view.bounds), -CGRectGetMidY(self.cardView.bounds))
        self.view.addSubview(self.cardView)
        
    }
    
    func showCardView() {
        titleLabel.hidden = true
        UIView.animateWithDuration(1.0) { () -> Void in
            self.cardView.center = CGPointMake(self.cardView.center.x, self.cardView.center.y + 500)
            self.status = .loginStatus
        }
    }
    //解决键盘弹出遮盖textField
    func keyboardWillChangeFrame(notification: NSNotification){
        let info: NSDictionary = notification.userInfo!
        let beginKeyboardRect = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue
        let endKeyboardRect = info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue
        
        let yOffset = (endKeyboardRect?.origin.y)! - (beginKeyboardRect?.origin.y)!
        for subview in self.view.subviews {
            if subview.isEqual(self.playerView) || subview.isEqual(self.titleLabel){
                continue
            }
            var frame = subview.frame
            frame.origin.y += yOffset
            subview.frame = frame
        }
        
    }
    
    
    @IBAction func loginClick(sender: AnyObject) {
        if status == currentStatus.freeStatus {
            transitionToNewStatus(currentStatus.loginStatus)
        }
        else if status == currentStatus.loginStatus {
            //发起登录请求
            let phone: String? = self.cardView.phone.text
            let pwd: String? = self.cardView.password.text
            if phone == nil || phone!.isEmpty || phone == "" {
                return
            }
            if pwd == nil || pwd!.isEmpty || pwd == "" {
                return
            }
            let para:[String: AnyObject] = ["phone":phone!, "password":pwd! ]
            hud.textLabel.text = "Loading"
            hud.showInView(self.view)
            NetBase.login(para).then{(json) -> Void in
                self.hud.hidden = true
                UserModel.saveUserData(json )
                let home = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
                self.presentViewController(home, animated: true, completion: nil)
            }.error{ (error) -> Void in
                self.hud.hidden = true
                print(error)
            }
        }
    }
    @IBAction func signClick(sender: AnyObject) {
        
    }
    func transitionToNewStatus(newStatus: currentStatus) {
        showCardView()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //            Alamofire.manager.request(.POST, "http://127.0.0.1:3008/login", parameters: para, encoding: ParameterEncoding.JSON, headers: nil).
    //
    //                .responseJSON(completionHandler: { (response) -> Void in
    //
    //            print(json)
    //            print( response.result )
    //        })


}
