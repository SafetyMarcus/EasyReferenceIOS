//
//  ReferenceListView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 1/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

protocol SaveReferenceDelegate
{
    func saveReference(reference: ReferenceItem)
}
protocol AddReferenceDelegate
{
    func addReference(type: ReferenceItem.ReferenceType)
}

class ReferenceListView: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveReferenceDelegate, AddReferenceDelegate
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var referenceList = ReferenceList()
    var selected = 0
    
    @IBOutlet
    var navBar: UINavigationBar!
    @IBOutlet
    var tableView: UITableView!
    
    func addReference(type: ReferenceItem.ReferenceType)
    {
        referenceList.references.append(ReferenceItem(parentId: referenceList.id, type: type))
        referenceList.saveList(appDelegate.managedObjectContext!)
        self.tableView.reloadData()
    }
    
    @IBAction func unwindToList(unwindSegue: UIStoryboardSegue){}
    
    override func viewWillDisappear(animated: Bool)
    {
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        var headerCell: ReferenceListHeaderCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ReferenceListHeaderCell

        referenceList.name = headerCell.title.text
        referenceList.save(appDelegate.managedObjectContext!)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "ReferenceListHeaderCell", bundle: nil), forCellReuseIdentifier: "ReferenceListHeader")
        self.title = referenceList.name
    }

    func saveReference(reference: ReferenceItem)
    {
        referenceList.references[selected] = reference
        referenceList.saveList(appDelegate.managedObjectContext!)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "ShowReferenceItem")
        {
            let editReferenceView: EditReferenceView = segue.destinationViewController.topViewController as! EditReferenceView
            editReferenceView.referenceItem = referenceList.references[selected]
            editReferenceView.saveReferenceDelegate = self
        }
        else if(segue.identifier == "SelectReferenceType")
        {
            let referenceTypeView: SelectReferenceTypeViewController = segue.destinationViewController.topViewController as! SelectReferenceTypeViewController
            referenceTypeView.delegate = self
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if(indexPath.row > 0)
        {
            return true
        }
        
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            referenceList.deleteReference(appDelegate.managedObjectContext!, row: indexPath.row - 1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0)
        {
            return 60
        }

        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.frame.width - 40, 9999))
        
        var currentReference = self.referenceList.references[indexPath.row - 1]
        var labelText = currentReference.getReferenceString()
        
        if(labelText.isEmpty)
        {
            labelText = "Click to edit!"
        }
        
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        
        label.text = labelText
        label.sizeToFit()
        return label.frame.height + 20
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        return referenceList.references.count + 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selected = indexPath.row - 1
        
        if(selected != -1)
        {
            performSegueWithIdentifier("ShowReferenceItem", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            var cell: ReferenceListHeaderCell = self.tableView.dequeueReusableCellWithIdentifier("ReferenceListHeader") as! ReferenceListHeaderCell
            cell.title.text = referenceList.name
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
        else
        {
            var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
            var currentReference = self.referenceList.references[indexPath.row - 1]
            var labelText = currentReference.getReferenceString()
        
            if(labelText.isEmpty)
            {
                labelText = "Click to edit!"
            }
        
            cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.textLabel!.text = labelText
            return cell
        }
    }
}