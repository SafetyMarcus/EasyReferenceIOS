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
    
    var selected = 0
    
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

            var picker = MFMailComposeViewController()
            picker.setSubject("\(self.referenceLists[indexPath.row].name)")
            picker.setMessageBody("Created in EasyReference", isHTML: false)
            
            let fileData = NSData(contentsOfFile: pdfPath)
            picker.addAttachmentData(fileData, mimeType: "application/pdf", fileName: "\(self.referenceLists[indexPath.row].name).pdf")
            
            self.presentViewController(picker, animated: true, completion: nil)
            })
        
        shareAction.backgroundColor = UIColor(red: 33/255, green: 219/255, blue: 86/255, alpha: 1)
        
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
        getReferences()
        self.tableView.reloadData()
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

