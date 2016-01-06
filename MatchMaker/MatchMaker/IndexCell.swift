//
//  IndexCell.swift
//  MatchMaker
//
//  Created by sue on 15/12/29.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit

class IndexCell: UITableViewCell {

    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hasMessage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.avaImage.layer.masksToBounds = true
        self.avaImage.layer.cornerRadius = (self.avaImage.frame.width) / 2
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .None
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
    }
}
