//
//  SelectReferenceTypeViewController.swift
//  EasyReference-IOS
//
//  Created by Marcus on 19/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit

class SelectReferenceTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "ReferenceTypeCell", bundle: nil), forCellReuseIdentifier: "ReferenceTypeCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: ReferenceTypeCell = self.tableView.dequeueReusableCellWithIdentifier("ReferenceTypeCell") as ReferenceTypeCell
        
        if(indexPath.row == 0)
        {
            cell.title.text = "Book"
            cell.typeImage.image = UIImage(named: "icon_book")
        }
        else if(indexPath.row == 1)
        {
            cell.title.text = "Journal"
            cell.typeImage.image = UIImage(named: "icon_journal")
        }
        else if(indexPath.row == 2)
        {
            cell.title.text = "Book Chapter"
            cell.typeImage.image = UIImage(named: "icon_book_chapter")
        }
        else if(indexPath.row == 3)
        {
            cell.title.text = "Web Page"
            cell.typeImage.image = UIImage(named: "webpage")
        }
        
        tintImageWhite(cell.typeImage)
        return cell
    }
    
    func tintImageWhite(imageView: UIImageView)
    {
        imageView.image = imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = UIColor.whiteColor()
    }
}
