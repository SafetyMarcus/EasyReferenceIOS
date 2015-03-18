//
//  ReferenceTypeViewController.swift
//  EasyReference-IOS
//
//  Created by Marcus on 18/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

class ReferenceTypeViewController: ViewController
{
    @IBOutlet weak var bookImage: UIImageView!
    
    override func viewDidLoad()
    {
        tintImageWhite(bookImage)
    }
    
    func tintImageWhite(imageView: UIImageView)
    {
        imageView.image = imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = UIColor.whiteColor()
    }
}