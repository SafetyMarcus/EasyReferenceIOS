//
//  AddAuthorViewController.swift
//  EasyReference-IOS
//
//  Created by Marcus on 16/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

class AddAuthorViewController: UIViewController
{
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var middleName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    var addAuthorDelegate: AddAuthorDelegate! = nil
    
    @IBAction func saveAuthor(_ sender: AnyObject)
    {
        addAuthorDelegate.addAuthor(NSString(string: firstName.text!), middleName: NSString(string: middleName.text!), lastName: NSString(string: lastName.text!))
        performSegue(withIdentifier: "UnwindToReference", sender: self)
    }
}
