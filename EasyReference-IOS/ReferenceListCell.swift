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
        super.init(coder: aDecoder)!
    }
    
    fileprivate func setUpView()
    {
        setUpTitle()
        setUpDivider()
    }
    
    fileprivate func setUpTitle()
    {
        title = UILabel(frame: CGRect(x: self.frame.origin.x + 10, y: self.frame.origin.y + 10, width: self.frame.width - 10, height: self.frame.height))
        title.textColor = UIColor.black
        title.backgroundColor = UIColor.white
        title.lineBreakMode = .byTruncatingTail
        title.numberOfLines = 2
        self.contentView.addSubview(title)
    }
    
    fileprivate func setUpDivider()
    {
        divider = UILabel(frame: CGRect(x: self.frame.origin.y + 20, y: self.frame.height + 15, width: self.frame.width + 35, height: 1))
        divider.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.contentView.addSubview(divider)
    }
    
    func showHint()
    {
        swipeLabel = UILabel(frame: CGRect(x: self.bounds.width, y: 0, width: 200, height: self.bounds.height))
        swipeLabel.text = "Swipe me!"
        swipeLabel.textAlignment = .center
        swipeLabel.backgroundColor = UIColor.red
        swipeLabel.textColor = UIColor.white
        self.contentView.addSubview(swipeLabel)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = CGRect(x: self.frame.origin.x - 200, y: self.frame.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
            self.title.alpha = 0.5
        })
    }
    
    func hideHint()
    {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = CGRect(x: self.frame.origin.x + 200, y: self.frame.origin.y, width: self.bounds.width, height: self.bounds.height)
            self.title.alpha = 1
            self.swipeLabel.removeFromSuperview()
            self.swipeLabel = nil
        })
    }
}
