//
//  String.swift
//  MatchMaker
//
//  Created by sue on 15/12/8.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

extension String {
    func heightForStr(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width,CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
        
    }
    func sizeForStr(fontSize: CGFloat, maxWidth: CGFloat) -> CGSize {
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(maxWidth,CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size
    }
    
}
