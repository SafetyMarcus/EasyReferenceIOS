//
//  EditReferenceView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 1/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

class EditReferenceView: UIViewController
{
    var referenceItem: ReferenceItem
    var saveReferenceDelegate: SaveReferenceDelegate! = nil
    
    @IBOutlet weak var editAuthor: UITextField!
    @IBOutlet weak var editDate: UITextField!
    @IBOutlet weak var editTitle: UITextField!
    @IBOutlet weak var editSubtitle: UITextField!
    @IBOutlet weak var editLocation: UITextField!
    @IBOutlet weak var editPublisher: UITextField!
    
    required init(coder aDecoder: NSCoder)
    {
        referenceItem = ReferenceItem()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        editAuthor.text = referenceItem.author
        editDate.text = referenceItem.date
        editTitle.text = referenceItem.title
        editSubtitle.text = referenceItem.subTitle
        editLocation.text = referenceItem.location
        editPublisher.text = referenceItem.publisher
    }
    
    @IBAction func saveAndReturn(sender: UIBarButtonItem)
    {
        referenceItem.author = editAuthor.text
        referenceItem.date = editDate.text
        referenceItem.title = editTitle.text
        referenceItem.subTitle = editSubtitle.text
        referenceItem.location = editLocation.text
        referenceItem.publisher = editPublisher.text
        
        saveReferenceDelegate.saveReference(referenceItem)
        
        performSegueWithIdentifier("UnwindToList", sender: sender)
    }
}
