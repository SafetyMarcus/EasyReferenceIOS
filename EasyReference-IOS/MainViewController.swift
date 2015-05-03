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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var referenceLists = [ReferenceList]()
    
    var selected = 0
    var addingList = false
    
    @IBOutlet
    var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        return referenceLists.count;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?
    {
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        
            var pdfPath = PDFGenerator(listId: self.referenceLists[indexPath.row].id, context: self.appDelegate.managedObjectContext!).generate()

            var mail = MFMailComposeViewController()
            mail.setSubject("\(self.referenceLists[indexPath.row].name)")
            mail.setMessageBody("Created in EasyReference", isHTML: false)
            mail.mailComposeDelegate = self
            
            let fileData = NSData(contentsOfFile: pdfPath)
            mail.addAttachmentData(fileData, mimeType: "application/pdf", fileName: "\(self.referenceLists[indexPath.row].name).pdf")
            
            self.presentViewController(mail, animated: true, completion: nil)
            })
        
        shareAction.backgroundColor = UIColor(red: 255/255, green: 110/255, blue: 100/255, alpha: 1)
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
        
            let managedContext = self.appDelegate.managedObjectContext!
            
            var error : NSError?
            let fetchRequest = NSFetchRequest(entityName: "ReferenceList")
            let fetchResults: [NSManagedObject] = (managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject])!
            
            let itemToDelete = fetchResults[indexPath.row]
            managedContext.deleteObject(itemToDelete)
            
            self.referenceLists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        })
            
        return [deleteAction, shareAction]
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        getReferences()
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
            addingList = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if(segue.identifier == "ShowReferenceList")
        {
            let referenceListView: ReferenceListView = segue.destinationViewController.topViewController as! ReferenceListView
            referenceListView.referenceList = referenceLists[selected]
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = self.referenceLists[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selected = indexPath.row
        self.performSegueWithIdentifier("ShowReferenceList", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "EasyReference"
    }
}

