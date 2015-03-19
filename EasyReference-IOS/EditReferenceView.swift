//
//  EditReferenceView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 1/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

protocol AddAuthorDelegate
{
    func addAuthor(firstName: NSString, middleName: NSString, lastName: NSString)
}

class EditReferenceView: UIViewController, AddAuthorDelegate
{
    var referenceItem: ReferenceItem! = nil
    var saveReferenceDelegate: SaveReferenceDelegate! = nil
    
    @IBOutlet weak var editAuthor: UITextField!
    @IBOutlet weak var editDate: UITextField!
    @IBOutlet weak var editTitle: UITextField!
    @IBOutlet weak var editSubtitle: UITextField!
    @IBOutlet weak var addAuthor: UIButton!
    
    @IBAction func unwindToEditReference(unwindSegue: UIStoryboardSegue){}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        editAuthor.text = referenceItem.author
        editDate.text = referenceItem.date
        editTitle.text = referenceItem.title
        editSubtitle.text = referenceItem.subTitle
        addAuthor.layer.cornerRadius = 2
    }
    
    func save()
    {
        referenceItem.author = editAuthor.text
        referenceItem.date = editDate.text
        referenceItem.title = editTitle.text
        referenceItem.subTitle = editSubtitle.text

    }
    
    func addAuthor(firstName: NSString, middleName: NSString, lastName: NSString)
    {
        var authors = ""
        
        if((editAuthor.text as NSString).length > 0)
        {
            authors = "\(editAuthor.text), "
        }
        
        if(lastName.length > 0)
        {
            authors += "\(lastName.substringToIndex(1).uppercaseString)\(lastName.substringFromIndex(1)), "
        }
        
        if(firstName.length > 0)
        {
            authors += "\(firstName.substringToIndex(1).uppercaseString). "
        }
        
        if(middleName.length > 0)
        {
            authors += "\(middleName.substringToIndex(1).uppercaseString). "
        }
        
        editAuthor.text = authors
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "ShowAddAuthor")
        {
            let addAuthorView: AddAuthorViewController = segue.destinationViewController.topViewController as AddAuthorViewController
            addAuthorView.addAuthorDelegate = self
        }
    }
}
