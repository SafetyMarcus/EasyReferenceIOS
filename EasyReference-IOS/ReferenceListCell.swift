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
    
    func setUpView(tableView: UITableView)
    {
        title = UILabel(frame: CGRectMake(10, 0, tableView.frame.width - 10, 50))
        title.textColor = UIColor.blackColor()
        title.backgroundColor = UIColor.whiteColor()
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(title)
    }
}