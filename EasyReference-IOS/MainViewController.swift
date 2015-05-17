//
//  ViewController.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var referenceLists = [ReferenceList]()
    
    var selected = -1
    var addingList = false
    var showHint = false
    
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptySubtitle: UILabel!
    
    @IBOutlet
    var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        var count = referenceLists.count
        
        if(count == 0)
        {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.emptyTitle.alpha = 1
                self.emptySubtitle.alpha = 1
                self.tableView.alpha = 0
            })
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.emptyTitle.alpha = 0
                self.emptySubtitle.alpha = 0
                self.tableView.alpha = 1
            })
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?
    {
        selected = indexPath.row
        
        var sendAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Send" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        
            self.performSegueWithIdentifier("ShowPDF", sender: self.tableView)
        })
        
        sendAction.backgroundColor = UIColor.orangeColor()
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
        
            let managedContext = self.appDelegate.managedObjectContext!
            
            var error : NSError?
            let fetchRequest = NSFetchRequest(entityName: "ReferenceList")
            let fetchResults: [NSManagedObject] = (managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject])!
            
            let itemToDelete = fetchResults[indexPath.row]
            managedContext.deleteObject(itemToDelete)
            
            self.referenceLists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            self.appDelegate.saveContext()
        })
            
        return [deleteAction, sendAction]
    }
    
    override func viewDidAppear(animated: Bool)
    {
        getReferences()
        
        if(showHint && !appDelegate.seenMainHint)
        {
            showHint = false
            appDelegate.seenMainHint = true
            appDelegate.saveSettings()
            
            showSendHint()
        }
    }
    
    func showSendHint()
    {
        var view = self.navigationController?.view
        var shadow = Shadow(frame: CGRectMake(0, 0, view!.frame.width, view!.frame.height))
        shadow.text = "Slide left to send your list\nas a PDF or remove it"
        view!.addSubview(shadow)
    }
    
    func getReferences()
    {
        referenceLists = [ReferenceList]()
        let managedContext = appDelegate.managedObjectContext!

        var error : NSError?
        let fetchRequest = NSFetchRequest(entityName: "ReferenceList")
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error)
        
        if(fetchResults?.count == 0)
        {
            return
        }
        
        if let results = fetchResults
        {
            for index in 0...results.count - 1
            {
                var referenceObject: NSManagedObject = results[index] as! NSManagedObject
                
                referenceLists.append(ReferenceList(reference: referenceObject, context: managedContext))
            }
        }
        
        referenceLists.sort({ $0.name > $1.name})
        
        self.tableView.reloadData()
    }
    
    @IBAction func addReferenceList(sender: UIBarButtonItem)
    {
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("ReferenceList", inManagedObjectContext: managedContext)
        let referenceList = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        referenceList.setValue("New Reference List", forKey: "name")
        referenceList.setValue(NSUUID().UUIDString, forKey: "id")
        
        var error : NSError?
        managedContext.save(&error)
        addingList = true
        getReferences()
        appDelegate.saveContext()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView.dragging)
        {
            CellSlideInTop.animate(cell)
        }
        
        if(addingList)
        {
            var path = NSIndexPath(forRow: referenceLists.count - 1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            
            if(indexPath.row == referenceLists.count - 1)
            {
                CellSlideInTop.animate(cell)
                addingList = false
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if(segue.identifier == "ShowReferenceList")
        {
            let referenceListView: ReferenceListView = segue.destinationViewController.topViewController as! ReferenceListView
            referenceListView.referenceList = referenceLists[selected]
            referenceListView.animateList = true
        }
        else if(segue.identifier == "ShowPDF")
        {
            let pdfController: PDFViewController = segue.destinationViewController.topViewController as! PDFViewController
            pdfController.referenceList = referenceLists[selected]
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: ReferenceListCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! ReferenceListCell
        cell.title.text = self.referenceLists[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)
    {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selected = indexPath.row
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        showHint = true
        
        self.performSegueWithIdentifier("ShowReferenceList", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.registerClass(ReferenceListCell.self, forCellReuseIdentifier: "cell")
        self.title = "EasyReference"
    }
}

