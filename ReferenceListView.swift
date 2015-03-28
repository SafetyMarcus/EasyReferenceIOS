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
    var referenceList: ReferenceList
    var selected = 0
    
    @IBOutlet
    var navBar: UINavigationBar!
    @IBOutlet
    var tableView: UITableView!
    
    required init(coder aDecoder: NSCoder)
    {
        self.referenceList = ReferenceList(name: "empty")
        super.init(coder: aDecoder)
    }
    
    func addReference(type: ReferenceItem.ReferenceType)
    {
        referenceList.references.append(ReferenceItem(type: type))
        self.tableView.reloadData()
    }
    
    @IBAction func unwindToList(unwindSegue: UIStoryboardSegue){}
    
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
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "ShowReferenceItem")
        {
            let editReferenceView: EditReferenceView = segue.destinationViewController.topViewController as EditReferenceView
            editReferenceView.referenceItem = referenceList.references[selected]
            editReferenceView.saveReferenceDelegate = self
        }
        else if(segue.identifier == "SelectReferenceType")
        {
            let referenceTypeView: SelectReferenceTypeViewController = segue.destinationViewController.topViewController as SelectReferenceTypeViewController
            referenceTypeView.delegate = self
        }
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
            var cell: ReferenceListHeaderCell = self.tableView.dequeueReusableCellWithIdentifier("ReferenceListHeader") as ReferenceListHeaderCell
            cell.title.text = referenceList.name
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
        else
        {
            var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
            var currentReference = self.referenceList.references[indexPath.row - 1]
            var labelText = currentReference.getReferenceString()
        
            if(labelText.isEmpty)
            {
                labelText = "Click to edit!"
            }
        
            cell.textLabel!.text = labelText
            return cell
        }
    }
}