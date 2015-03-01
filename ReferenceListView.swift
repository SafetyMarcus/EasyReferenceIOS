//
//  ReferenceListView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 1/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation

class ReferenceListView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var referenceList: ReferenceList
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        return referenceList.references.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel!.text = self.referenceList.references[indexPath.row].getReferenceString()
        
        return cell
    }
}