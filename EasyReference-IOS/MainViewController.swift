//
//  ViewController.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var referenceLists = [ReferenceList]()
    
    var selected = 0
    
    @IBOutlet
    var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        getReferences()
        return referenceLists.count;
    }
    
    func getReferences()
    {
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
                
                referenceLists.append(ReferenceList(reference: referenceObject, managedContext))
            }
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

