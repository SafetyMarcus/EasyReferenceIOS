//
//  EditReferenceAuthorCell.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

class EditReferenceAuthorCell: UITableViewCell
{
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var referenceText: UITextField!
    @IBOutlet weak var addAuthor: UIButton!
    
    var delegate: AddAuthorListener! = nil
    
    @IBAction func clickedAddAuthor(sender: UIButton)
    {
        self.delegate.clickedAddAuthor()
    }
}