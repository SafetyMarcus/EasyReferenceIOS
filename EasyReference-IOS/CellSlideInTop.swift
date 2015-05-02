//
//  CellSlideInTop.swift
//  EasyReference-IOS
//
//  Created by Marcus on 2/05/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

class CellSlideInTop
{
    class func animate(cell: UITableViewCell)
    {
        let translation = CATransform3DMakeTranslation(0, -20, 1)
        
        cell.layer.shadowColor = UIColor.blackColor() as! CGColor
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = translation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        UIView.beginAnimations("translation", context: nil)
        UIView.setAnimationDuration(0.8)
        
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        UIView.commitAnimations()
    }

}