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

class ReferenceListView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, SaveReferenceDelegate, AddReferenceDelegate, ShowingDelegate
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var referenceList = ReferenceList()
    var selected = 0
    var stretchyHeader = UIView()
    var animateList = false
    var didAddReference = false
    
    var showHint = false
    var hintCell: ReferenceListCell!
    
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptySubtitle: UILabel!
    
    @IBOutlet
    var tableView: UITableView!
    
    func addReference(type: ReferenceItem.ReferenceType)
    {
        var newReference = ReferenceItem(parentId: referenceList.id, type: type)
        
        referenceList.addReference(newReference)
        referenceList.saveList(appDelegate.managedObjectContext!)
        self.tableView.reloadData()
        
        selected = (referenceList.getReferences() as NSArray).indexOfObject(newReference)
        didAddReference = true
    }
    
    @IBAction func unwindToList(unwindSegue: UIStoryboardSegue){}
    
    override func viewWillAppear(animated: Bool)
    {
        if(animateList)
        {
            animateList = false
            tableView.reloadData()
        
            let cells = tableView.visibleCells()
            let tableHeight: CGFloat = tableView.bounds.size.height
        
            for i in cells
            {
                if let cell: UITableViewCell = i as? ReferenceListCell
                {
                    cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
                }
            }
        
            var index = 0
        
            for a in cells
            {
                if let cell: ReferenceListCell = a as? ReferenceListCell
                {
                    UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:        nil, animations: {
                            cell.transform = CGAffineTransformMakeTranslation(0, 0);},
                        completion: nil)
            
                    index += 1
                }
            }
        }
    }
    
    func showDeleteHint()
    {
        var view = self.navigationController?.view
        var shadow = Shadow(frame: CGRectMake(0, 0, view!.frame.width, view!.frame.height))
        shadow.finishDelegate = self
        view!.addSubview(shadow)
        
        hintCell.showHint()
    }
    
    func finishedShowing()
    {
        hintCell.hideHint()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        var headerCell: ReferenceListHeaderCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ReferenceListHeaderCell

        referenceList.name = headerCell.title.text
        referenceList.save(appDelegate.managedObjectContext!)
        appDelegate.saveContext()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        stretchyHeader = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 4))
        stretchyHeader.backgroundColor = UIColor.redColor()
        
        tableView.addSubview(stretchyHeader)
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -60)
        
        self.tableView.registerClass(ReferenceListCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "ReferenceListHeaderCell", bundle: nil), forCellReuseIdentifier: "ReferenceListHeader")
        self.title = referenceList.name
        appDelegate.saveContext()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if(didAddReference)
        {
            didAddReference = false
            performSegueWithIdentifier("ShowReferenceItem", sender: self.tableView)
        }
        
        if(showHint && !appDelegate.seenReferenceHint)
        {
            appDelegate.seenReferenceHint = true
            appDelegate.saveSettings()
            
            showHint = false
            showDeleteHint()
        }
    }

    func updateStretchyHeader()
    {
        var stretchyRect = CGRect(x: 0, y: -4, width: self.tableView.bounds.width, height: 4)
        if(self.tableView.contentOffset.y < -4)
        {
            stretchyRect.origin.y = self.tableView.contentOffset.y
            stretchyRect.size.height = -tableView.contentOffset.y
        }
        
        self.stretchyHeader.frame = stretchyRect
    }
    
    func saveReference(reference: ReferenceItem)
    {
        showHint = true
        var references = referenceList.getReferences()
        references[selected] = reference
        referenceList.saveList(appDelegate.managedObjectContext!)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "ShowReferenceItem")
        {
            self.navigationItem.title = "Save"
            let editReferenceView: EditReferenceView = segue.destinationViewController.topViewController as! EditReferenceView
            var references = referenceList.getReferences()
            editReferenceView.referenceItem = references[selected]
            editReferenceView.saveReferenceDelegate = self
        }
        else if(segue.identifier == "SelectReferenceType")
        {
            self.navigationItem.title = "Cancel"
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?
    {
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (UITableViewRowAction, indexPath: NSIndexPath!) -> Void in
                self.referenceList.deleteReference(self.appDelegate.managedObjectContext!, row: indexPath.row - 1)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0)
        {
            return 60
        }

        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.frame.width - 40, 9999))
        
        var references = referenceList.getReferences()
        var currentReference = references[indexPath.row - 1]
        var labelText = currentReference.getReferenceString()
        
        if(labelText.isEmpty)
        {
            labelText = "Click to edit!"
        }
        
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        
        label.text = labelText
        label.sizeToFit()
        
        var size = label.frame.height + 20
        if(size < 60)
        {
            size = 60
        }
        
        return size
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        var references = referenceList.getReferences()
        var count = references.count + 1;
        
        if(count <= 1)
        {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.emptyTitle.alpha = 1
                self.emptySubtitle.alpha = 1
            })
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.emptyTitle.alpha = 0
                self.emptySubtitle.alpha = 0
            })
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        selected = indexPath.row - 1
        
        if(selected != -1)
        {
            performSegueWithIdentifier("ShowReferenceItem", sender: self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    func scrollViewDidScroll(scrollView: UIScrollView)
    {
       updateStretchyHeader()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)
    {
        updateStretchyHeader()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            var cell = self.tableView.dequeueReusableCellWithIdentifier("ReferenceListHeader") as! ReferenceListHeaderCell
            cell.title.text = referenceList.name
            cell.title.returnKeyType = .Done
            cell.title.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
        else
        {
            var cell: ReferenceListCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! ReferenceListCell
            
            var references = referenceList.getReferences()
            var currentReference = references[indexPath.row - 1]
            var labelText = currentReference.getReferenceString()
        
            if(labelText.isEmpty)
            {
                labelText = "Click to edit!"
            }
        
            cell.title.text = labelText
            
            if(showHint && hintCell == nil)
            {
                hintCell = cell
            }
            
            return cell
        }
    }
}