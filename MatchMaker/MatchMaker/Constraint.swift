//
//  Constraint.swift
//  MatchMaker
//
//  Created by sue on 15/12/6.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import SwiftyJSON

let SCREEN_WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.size.height


class Constraint: NSObject {
   static func jsonConvert(json: JSON) -> [String: AnyObject] {
        var result: [String: AnyObject] = [String: AnyObject]()
//         for (key, object) in json. {
//            result[key] = object.stringValue
//        }
        return result
    }
}
