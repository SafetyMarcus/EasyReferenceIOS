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
        self.textColor = UIColor.white
        self.textAlignment = NSTextAlignment.center
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.5)
        
        self.isUserInteractionEnabled = true
        let gestureRecogniser = UITapGestureRecognizer()
        gestureRecogniser.addTarget(self, action: #selector(Shadow.tappedShadow))
        self.addGestureRecognizer(gestureRecogniser)
        
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 1
        })
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
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
