//
//  CardView.swift
//  GIFWelcome
//
//  Created by sue on 15/10/16.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var phone: UITextField!
    var password: UITextField!
    var loginBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        let frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        for var i = 0; i < 2; i++ {
            let field = UITextField(frame: CGRectMake(0,0,220,30))
            field.borderStyle = UITextBorderStyle.RoundedRect
            field.center = CGPointMake(self.frame.size.width/2,  50 + CGFloat(i * 50))
            field.backgroundColor = UIColor.whiteColor()
            field.placeholder = i == 1 ? "密码" : "用户名"
            field.secureTextEntry = i == 1 ? true : false
            field.keyboardAppearance = UIKeyboardAppearance.Dark
            if i == 1 {
                self.password = field
                self.password.text = "123456"
            }else{
                self.phone = field
                self.phone.text = "15868869697"
            }
            self.addSubview(field)
        }
        
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for subview in self.subviews {
            subview.resignFirstResponder()
        }
    }

    
    
}


