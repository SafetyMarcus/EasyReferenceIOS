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
    
    @IBAction func clickedAddAuthor(_ sender: UIButton)
    {
        self.delegate.clickedAddAuthor()
    }
    
    @IBAction func clickedReferenceText(_ sender: Any)
    {
        if self.referenceText.text?.characters.count == 0
        {
            self.delegate.clickedAddAuthor()
        }
    }
}
