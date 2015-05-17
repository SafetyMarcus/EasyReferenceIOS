//
//  Shadow.swift
//  EasyReference-IOS
//
//  Created by Marcus on 17/05/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

protocol ShowingDelegate
{
    func finishedShowing()
}

class Shadow: UILabel
{
    var finishDelegate: ShowingDelegate!

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.numberOfLines = 2
        self.text = "Slide left to delete references!"
        self.textColor = UIColor.whiteColor()
        self.textAlignment = NSTextAlignment.Center
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.5)
        
        self.userInteractionEnabled = true
        var gestureRecogniser = UITapGestureRecognizer()
        gestureRecogniser.addTarget(self, action: "tappedShadow")
        self.addGestureRecognizer(gestureRecogniser)
        
        self.alpha = 0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 1
        })
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tappedShadow()
    {
        self.removeFromSuperview()
        
        if finishDelegate != nil
        {
            finishDelegate.finishedShowing()
        }
    }
}