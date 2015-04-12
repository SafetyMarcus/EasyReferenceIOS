//
//  ViewController.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var items: [ReferenceList] = (UIApplication.sharedApplication().delegate as! AppDelegate).referenceLists
    var selected = 0
    
    @IBOutlet
    var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        return self.items.count;
    }
    
    @IBAction func addReferenceList(sender: UIBarButtonItem)
    {
        var count = items.count + 1
        items.append(ReferenceList(name: "Reference List \(count)"))
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if(segue.identifier == "ShowReferenceList")
        {
            let referenceListView: ReferenceListView = segue.destinationViewController.topViewController as! ReferenceListView
            referenceListView.referenceList = items[selected]
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = self.items[indexPath.row].name
        
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

