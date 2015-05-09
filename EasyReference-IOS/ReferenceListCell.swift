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
    
    var edit = UIImageView(frame: CGRectMake(25, 25, 25, 25))
    var share = UILabel(frame: CGRectMake(75, 25, 25, 25))
    var delete = UILabel(frame: CGRectMake(125, 25, 25, 25))
    
    func setUpView(tableView: UITableView)
    {
        title = UILabel(frame: CGRectMake(10, 0, tableView.frame.width - 10, 50))
        title.textColor = UIColor.blackColor()
        title.backgroundColor = UIColor.whiteColor()
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(title)
        
        edit = UIImageView(frame: CGRectMake(0, title.frame.height, tableView.frame.width/3, tableView.frame.width/3))
        edit.backgroundColor = UIColor.redColor()
        var image = UIImage(named: "icon_edit")
        edit.image = UIImage(named: "icon_edit")
        edit.contentMode = UIViewContentMode.Center
        self.contentView.addSubview(edit)
        
        share = UILabel(frame: CGRectMake(tableView.frame.width/3, title.frame.height, tableView.frame.width/3, tableView.frame.width/3))
        share.text = "Share"
        share.backgroundColor = UIColor.redColor()
        share.textAlignment = NSTextAlignment.Center
        share.textColor = UIColor.whiteColor()
        self.contentView.addSubview(share)

        delete = UILabel(frame: CGRectMake((tableView.frame.width/3) * 2, title.frame.height, tableView.frame.width/3, tableView.frame.width/3))
        delete.text = "Delete"
        delete.backgroundColor = UIColor.redColor()
        delete.textAlignment = NSTextAlignment.Center
        delete.textColor = UIColor.whiteColor()
        self.contentView.addSubview(delete)
    }
}