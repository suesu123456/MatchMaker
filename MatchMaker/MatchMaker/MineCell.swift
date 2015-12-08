//
//  MineCell.swift
//  MatchMaker
//
//  Created by sue on 15/12/7.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class MineCell: UITableViewCell {

    var titleLabel: UILabel!
    var ava: UIButton!
    var praise: UIButton!
    var praiseNum: UIButton!
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel(frame: CGRectMake(5, 10, self.frame.size.width - 10 - 50, 24))
        titleLabel.font = UIFont.systemFontOfSize(14)
        addSubview(titleLabel)
        
        ava = UIButton(frame: CGRectMake(titleLabel.frame.maxX, 10, 24, 24))
        ava.layer.masksToBounds = true
        ava.layer.cornerRadius = 12
        praise = UIButton(frame: CGRectMake(ava.frame.maxX, 12, 24, 24))
        praise.setImage(UIImage(named: "thumbup"), forState: UIControlState.Normal)
        praise.contentMode = UIViewContentMode.ScaleAspectFit
        
        praiseNum = UIButton(frame: CGRectMake(praise.frame.origin.x + 10, 25, 15, 15))
        praiseNum.backgroundColor = UIColor.blackColor()
        praiseNum.layer.masksToBounds = true
        praiseNum.layer.cornerRadius = 7.5
        praiseNum.titleLabel?.font = UIFont.systemFontOfSize(10)
        addSubview(ava)
        addSubview(praise)
        addSubview(praiseNum)
    }
    
    func setData() {
        titleLabel.text = "人非常nice哦"
        ava.setImage(UIImage(named: "photo_peach"), forState: UIControlState.Normal)
        praiseNum.setTitle("2", forState: UIControlState.Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
