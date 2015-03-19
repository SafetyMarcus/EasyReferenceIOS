//
//  EditBookReferenceView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 19/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

class EditBookReferenceView: EditReferenceView
{
    @IBOutlet weak var editLocation: UITextField!
    @IBOutlet weak var editPublisher: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        editLocation.text = referenceItem.location
        editPublisher.text = referenceItem.publisher
        addAuthor.layer.cornerRadius = 2
    }
    
    override func save()
    {
        super.save()
        referenceItem.location = editLocation.text
        referenceItem.publisher = editPublisher.text
    }

    @IBAction func saveAndReturn(sender: AnyObject)
    {
        save()
        saveReferenceDelegate.saveReference(referenceItem)
        performSegueWithIdentifier("UnwindToList", sender: sender)
    }
}
