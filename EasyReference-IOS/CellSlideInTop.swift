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
    class func animate(_ cell: UITableViewCell)
    {
        let translation = CATransform3DMakeTranslation(0, -20, 1)
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10);
        cell.alpha = 0.2;
        
        cell.layer.transform = translation;
        
        UIView.beginAnimations("translation", context: nil)
        UIView.setAnimationDuration(0.8)
        
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSize(width: 0, height: 0);
        UIView.commitAnimations()
    }
}
