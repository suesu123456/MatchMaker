//
//  SFPatchView.swift
//  TagCloud
//
//  Created by sue on 15/11/30.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class SFPatchView: UIView, UIActionSheetDelegate {

    var leftBtton: UIButton!
    var lineImage: UIImageView!
    var btnArray: [UIButton] = []
    var btnWidth: CGFloat = 60
    var beginAngle: CGFloat = 30 // 起始角度
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBtn(btn: UIButton, array: [String]) {
        leftBtton = btn
        leftBtton.frame = CGRectMake(0, frame.size.height/2 - 32, btnWidth, btnWidth)
        let panGes = UIPanGestureRecognizer(target: self, action: Selector("btnDrag:"))
        panGes.maximumNumberOfTouches = 1
        panGes.minimumNumberOfTouches = 1
        leftBtton.addGestureRecognizer(panGes)
        startPoint = CGPoint(x: btnWidth/2, y: leftBtton.frame.origin.y + btnWidth/2)
        addSubview(leftBtton)
        for var i = 0; i < array.count; i++ {
            let btn = UIButton(frame: calcCircleFrame(i))
            btn.setImage(UIImage(named: array[i]), forState: UIControlState.Normal)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0 , bottom: 50, right: 0)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 30
            btnArray.append(btn)
            self.insertSubview(btn, belowSubview: leftBtton)
        }
    }
    // 圆形排版
    func calcCircleFrame(i: Int) -> CGRect {
        //起始角度
        let angle = beginAngle * CGFloat(i + 1)
        let r: CGFloat = frame.height / 2.5 //半径
        let a = angle * CGFloat(M_PI) / 180.0 // 角度
        var x: CGFloat = 0
        var y: CGFloat = 0
        x = (sin(a)) * r
        y = (cos(a) * r) + r
        return CGRectMake(x, y, btnWidth, btnWidth)
    }
    //拖拉
    func btnDrag(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Changed {
            endPoint = sender.locationInView(self)
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            if isExitInpoint() {
                drawLine()
            }
        }
    
    }
    
    func isExitInpoint() -> Bool {
        for var btn in btnArray {
            if CGRectContainsPoint(btn.frame, endPoint) {
                endPoint = CGPoint(x: btn.frame.origin.x + btnWidth/2, y: btn.frame.origin.y + btnWidth/2)
                return true
            }
        }
        return false
    }
    
    //画线
    func drawLine() {
        UIGraphicsBeginImageContext(self.bounds.size)
        let context: CGContextRef? = UIGraphicsGetCurrentContext()
        var image: UIImage!
        if context != nil {
            CGContextSetShouldAntialias(context, true)
            CGContextSetLineWidth(context, 1)
            CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
            //直线
            CGContextMoveToPoint(context, startPoint.x, startPoint.y)
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
            CGContextStrokePath(context)
            //箭头
            CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
            CGContextAddEllipseInRect(context, CGRectMake(endPoint.x, endPoint.y - 3, 5, 5))
            CGContextFillPath(context)
            
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            lineImage = UIImageView(image: image)
            self.addSubview(lineImage)
        }
       
        
    }

}
