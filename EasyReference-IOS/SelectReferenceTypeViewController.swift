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
    
    var delegate: AddReferenceDelegate! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.rowHeight = 70
        self.tableView.register(UINib(nibName: "ReferenceTypeCell", bundle: nil), forCellReuseIdentifier: "ReferenceTypeCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: ReferenceTypeCell = self.tableView.dequeueReusableCell(withIdentifier: "ReferenceTypeCell") as! ReferenceTypeCell
        
        if((indexPath as NSIndexPath).row == 0)
        {
            cell.title.text = "Book"
            cell.typeImage.image = UIImage(named: "icon_book")
        }
        else if((indexPath as NSIndexPath).row == 1)
        {
            cell.title.text = "Journal"
            cell.typeImage.image = UIImage(named: "icon_journal")
        }
        else if((indexPath as NSIndexPath).row == 2)
        {
            cell.title.text = "Book Chapter"
            cell.typeImage.image = UIImage(named: "icon_book_chapter")
        }
        else if((indexPath as NSIndexPath).row == 3)
        {
            cell.title.text = "Web Page"
            cell.typeImage.image = UIImage(named: "webpage")
        }
        
        tintImageWhite(cell.typeImage)
        return cell
    }
    
    func tintImageWhite(_ imageView: UIImageView)
    {
        imageView.image = imageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView.tintColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        delegate.addReference(getTypeForPosition((indexPath as NSIndexPath).row))
        performSegue(withIdentifier: "UnwindToList", sender: self)
    }
    
    func getTypeForPosition(_ position: NSInteger) -> ReferenceItem.ReferenceType
    {
        if(position == 0)
        {
            return ReferenceItem.ReferenceType.book
        }
        else if(position == 1)
        {
            return ReferenceItem.ReferenceType.journal
        }
        else if(position == 2)
        {
            return ReferenceItem.ReferenceType.bookChapter
        }
        else if(position == 3)
        {
            return ReferenceItem.ReferenceType.webPage
        }
        
        return ReferenceItem.ReferenceType.book
    }
}
