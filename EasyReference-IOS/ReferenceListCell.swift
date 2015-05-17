//
//  ReferenceListCell.swift
//  EasyReference-IOS
//
//  Created by Marcus on 9/05/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

class ReferenceListCell: UITableViewCell
{
    var title: UILabel!
    var divider: UILabel!
    var swipeLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    private func setUpView()
    {
        setUpTitle()
        divider = UILabel(frame: CGRectMake(self.frame.origin.y + 20, self.frame.height + 15, self.frame.width + 35, 1))
        divider.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.contentView.addSubview(divider)
    }
    
    private func setUpTitle()
    {
        title = UILabel(frame: CGRectMake(self.frame.origin.x + 10, self.frame.origin.y + 10, self.frame.width - 10, self.frame.height))
        title.textColor = UIColor.blackColor()
        title.backgroundColor = UIColor.whiteColor()
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 0
        self.contentView.addSubview(title)
    }
    
    func showHint()
    {
        swipeLabel = UILabel(frame: CGRectMake(self.bounds.width, 0, 200, self.bounds.height))
        swipeLabel.text = "Swipe me!"
        swipeLabel.textAlignment = .Center
        swipeLabel.backgroundColor = UIColor.redColor()
        swipeLabel.textColor = UIColor.whiteColor()
        self.contentView.addSubview(swipeLabel)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = CGRectMake(self.frame.origin.x - 200, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height)
            self.title.alpha = 0.5
        })
    }
    
    func hideHint()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = CGRectMake(self.frame.origin.x + 200, self.frame.origin.y, self.bounds.width, self.bounds.height)
            self.title.alpha = 1
            self.swipeLabel.removeFromSuperview()
            self.swipeLabel = nil
        })
    }
}