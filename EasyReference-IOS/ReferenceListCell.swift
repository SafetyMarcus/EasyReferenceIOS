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
    
    func setUpView(tableView: UITableView)
    {
        title.removeFromSuperview()
        divider.removeFromSuperview()
        
        title = UILabel(frame: CGRectMake(10, 10, tableView.frame.width - 10, 50))
        title.textColor = UIColor.blackColor()
        title.backgroundColor = UIColor.whiteColor()
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(title)
        
        divider = UILabel(frame: CGRectMake(20, 59, tableView.frame.width, 1))
        divider.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.contentView.addSubview(divider)
    }
}