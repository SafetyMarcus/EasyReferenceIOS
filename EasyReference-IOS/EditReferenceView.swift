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
    var animateIn = false
    
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
        referenceItem.save((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!)
        saveReferenceDelegate.saveReference(referenceItem)
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
            
            if((referenceItem.author as NSString).length > 0)
            {
                cell.referenceText.enabled = true
            }
            else
            {
                cell.referenceText.enabled = false
            }
            
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
            cell.referenceText.autocapitalizationType = referenceItem.getTextInputForCell(indexPath.row)
            
            return cell
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if(animateIn)
        {
            animateIn = false
            tableView.reloadData()
        
            let cells = tableView.visibleCells()
            let tableWidth: CGFloat = tableView.bounds.size.width
        
            for i in cells
            {
                if let cell: UITableViewCell = i as? UITableViewCell
                {
                    cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
                }
            }
        
            var index = 0
        
            for a in cells
            {
                if let cell: UITableViewCell = a as? UITableViewCell
                {
                    UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:       nil, animations: {
                        cell.transform = CGAffineTransformMakeTranslation(0, 0);},
                        completion: nil)
                
                    index += 1
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        save()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString replacement: String) -> Bool
    {
        let original = (textField.text as NSString).substringWithRange(range)
        let new = replacement
        if(original != new)
        {
            var cell: UITableViewCell = textField.superview?.superview as! UITableViewCell
            
            var row: NSIndexPath = (self.tableView.indexPathForCell(cell) as NSIndexPath?)!
            var position = row.row
            
            var textFieldText: NSString = textField.text
            var total = "\(textFieldText.substringToIndex(range.location))"
            total += "\(replacement)"
            total += "\(textFieldText.substringFromIndex(range.location + range.length))"
            
            referenceItem.saveValueForPosition(position, value: total)

            return true
        }
        
        return false
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
            authors = referenceItem.author.stringByReplacingOccurrencesOfString(" &", withString: "")
            authors = "\(authors), & "
        }
        
        if(lastName.length > 0)
        {
            authors += "\(lastName.substringToIndex(1).uppercaseString)\(lastName.substringFromIndex(1)), "
        }
        
        if(firstName.length > 0)
        {
            authors += "\(firstName.substringToIndex(1).uppercaseString)."
        }
        
        if(middleName.length > 0)
        {
            authors += " \(middleName.substringToIndex(1).uppercaseString)."
        }
        
        authorCell.referenceText.text = authors
        
        if((authors as NSString).length > 0)
        {
            authorCell.referenceText.enabled = true
        }

        referenceItem.saveValueForPosition(0, value: authors)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "ShowAddAuthor")
        {
            let addAuthorView: AddAuthorViewController = segue.destinationViewController.topViewController as! AddAuthorViewController
            addAuthorView.addAuthorDelegate = self
        }
    }
}
