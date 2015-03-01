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
    var items: [ReferenceList] = (UIApplication.sharedApplication().delegate as AppDelegate).referenceLists
    
    @IBOutlet
    var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        return self.items.count;
    }
    
    @IBAction func addReferenceList(sender: UIButton)
    {
        var count = items.count + 1
        items.append(ReferenceList(name: "Reference List \(count)"))
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel!.text = self.items[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("You selected cell #\(indexPath.row)!")
        self.performSegueWithIdentifier("ShowReferenceList", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

