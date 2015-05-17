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
    var title: UILabel = UILabel(frame: CGRectMake(10, 0, 500, 50))
    var divider: UILabel = UILabel(frame: CGRectMake(10, 0, 500, 50))
    var swipeLabel: UILabel!
    
    func setUpView(tableView: UITableView)
    {
        title.removeFromSuperview()
        divider.removeFromSuperview()
        
        setUpTitle(tableView)
        divider = UILabel(frame: CGRectMake(20, self.bounds.height - 1, tableView.frame.width, 1))
        divider.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.contentView.addSubview(divider)
    }
    
    private func setUpTitle(tableView: UITableView)
    {
        title = UILabel(frame: CGRectMake(10, 0, tableView.frame.width - 10, self.bounds.height))
        title.textColor = UIColor.blackColor()
        title.backgroundColor = UIColor.whiteColor()
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 0
        self.contentView.addSubview(title)
    }
    
    func showHint(tableView: UITableView)
    {
        swipeLabel = UILabel(frame: CGRectMake(self.bounds.size.width, 0, 200, self.bounds.height))
        swipeLabel.text = "Swipe me!"
        swipeLabel.textAlignment = .Center
        swipeLabel.backgroundColor = UIColor.redColor()
        swipeLabel.textColor = UIColor.whiteColor()
        self.contentView.addSubview(swipeLabel)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = CGRectMake(self.frame.origin.x - 200, self.frame.origin.y, self.bounds.width, self.bounds.height)
            self.title.alpha = 0.5
        })
    }
    
    func hideHint(tableView: UITableView)
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = CGRectMake(self.frame.origin.x + 200, self.frame.origin.y, self.bounds.width, self.bounds.height)
            self.title.alpha = 1
            self.swipeLabel.removeFromSuperview()
            self.swipeLabel = nil
        })
    }
}