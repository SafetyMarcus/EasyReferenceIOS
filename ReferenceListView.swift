//
//  ReferenceListView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 1/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

class ReferenceListView: UIViewController, UITableViewDelegate, UITableViewDataSource
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
    
    @IBAction func addReference(sender: UIButton)
    {
        referenceList.references.append(ReferenceItem())
        self.tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navBar.topItem?.title = referenceList.name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        return referenceList.references.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selected = indexPath.row
        self.performSegueWithIdentifier("ShowReferenceItem", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var currentReference = self.referenceList.references[indexPath.row]
        var labelText = currentReference.getReferenceString()
        
        if(labelText.isEmpty)
        {
            labelText = "Click to edit!"
        }
        
        cell.textLabel!.text = labelText
        
        return cell
    }
}