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

protocol AddAuthorListener
{
    func clickedAddAuthor()
}

class EditReferenceView: UITableViewController, UITableViewDataSource, UITableViewDelegate, AddAuthorDelegate, AddAuthorListener, UITextFieldDelegate
{
    var referenceItem: ReferenceItem! = nil
    var saveReferenceDelegate: SaveReferenceDelegate! = nil
    
    @IBAction func unwindToEditReference(unwindSegue: UIStoryboardSegue){}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
        self.tableView.allowsSelection = false
        self.tableView.registerNib(UINib(nibName: "EditReferenceAuthorCell", bundle: nil), forCellReuseIdentifier: "authorCell")
        self.tableView.registerNib(UINib(nibName: "EditReferenceCell", bundle: nil), forCellReuseIdentifier: "referenceCell")
    }
    
    func save()
    {
        for index in 0...self.tableView.numberOfRowsInSection(0)
        {
            var value = ""
            
            var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            if let authorCell = cell as? EditReferenceAuthorCell
            {
                value = authorCell.referenceText.text
            }
            else if let referenceCell = cell as? EditReferenceCell
            {
                value = referenceCell.referenceText.text
            }
            
            referenceItem.saveValueForPosition(index, value: value)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return referenceItem.getNumberOfCells()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            var cell: EditReferenceAuthorCell = self.tableView.dequeueReusableCellWithIdentifier("authorCell") as! EditReferenceAuthorCell
            cell.referenceText.text = referenceItem.author
            cell.delegate = self
            cell.referenceText.delegate = self
            cell.referenceText.returnKeyType = .Done
            
            return cell
        }
        else
        {
            var cell: EditReferenceCell = self.tableView.dequeueReusableCellWithIdentifier("referenceCell") as! EditReferenceCell
            cell.referenceLabel.text = referenceItem.getLabelsForCells()[indexPath.row]
            cell.referenceText.placeholder = referenceItem.getHintsForCells()[indexPath.row]
            cell.referenceText.text = referenceItem.getValueForPosition(indexPath.row)
            cell.referenceText.delegate = self
            cell.referenceText.returnKeyType = .Done
            
            return cell
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        var cell: UITableViewCell = textField.superview?.superview as! UITableViewCell
        
        var row = self.tableView.indexPathForCell(cell)
        var position = row?.row
        var value = textField.text
        
        referenceItem.saveValueForPosition(position!, value: value)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func getLabelForPosition(position: NSInteger) -> String
    {
        return referenceItem.getLabelsForCells()[position]
    }
    
    func clickedAddAuthor()
    {
        performSegueWithIdentifier("ShowAddAuthor", sender: self)
    }
    
    func addAuthor(firstName: NSString, middleName: NSString, lastName: NSString)
    {
        let authorCell: EditReferenceAuthorCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! EditReferenceAuthorCell
        var authors = ""
        
        if((referenceItem.author as NSString).length > 0)
        {
            authors = "\(referenceItem.author), "
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
        
        authorCell.referenceText.text = authors
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "ShowAddAuthor")
        {
            let addAuthorView: AddAuthorViewController = segue.destinationViewController.topViewController as! AddAuthorViewController
            addAuthorView.addAuthorDelegate = self
        }
    }
    
    @IBAction func saveAndReturn(sender: AnyObject)
    {
        save()
        saveReferenceDelegate.saveReference(referenceItem)
        performSegueWithIdentifier("UnwindToList", sender: sender)
    }
}
