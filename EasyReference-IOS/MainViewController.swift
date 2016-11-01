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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShowingDelegate
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var referenceLists = [ReferenceList]()
    
    var selected = -1
    var addingList = false
    var showHint = false
    
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptySubtitle: UILabel!
    
    @IBOutlet
    var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        let count = referenceLists.count
        
        if(count == 0)
        {
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.emptyTitle.alpha = 1
                self.emptySubtitle.alpha = 1
                self.tableView.alpha = 0
            })
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.emptyTitle.alpha = 0
                self.emptySubtitle.alpha = 0
                self.tableView.alpha = 1
            })
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]?
    {
        selected = (indexPath as NSIndexPath).row
        
        let sendAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Send" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
        
            self.performSegue(withIdentifier: "ShowPDF", sender: self.tableView)
        })
        
        sendAction.backgroundColor = UIColor.orange
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
        
            let managedContext = self.appDelegate.managedObjectContext!
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReferenceList")
            let predicate = NSPredicate(format: "id == %@", self.referenceLists[indexPath.row].id)
            fetchRequest.predicate = predicate
            
            let fetchResults: [NSManagedObject] = try! (managedContext.fetch(fetchRequest) as? [NSManagedObject])!
            
            let itemToDelete = fetchResults[0]
            managedContext.delete(itemToDelete)
            
            self.referenceLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            self.appDelegate.saveContext()
        })
            
        return [deleteAction, sendAction]
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool)
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
        let view = self.navigationController?.view
        let shadow = Shadow(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: view!.frame.height))
        shadow.text = "Slide left to send your list\nas a PDF or remove it"
        shadow.finishDelegate = self
        view!.addSubview(shadow)
        
        if(self.tableView.numberOfRows(inSection: 0) > 0)
        {
            (self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! ReferenceListCell).showHint()
        }
    }
    
    func finishedShowing()
    {
        (self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! ReferenceListCell).hideHint()
    }
    
    func getReferences()
    {
        referenceLists = [ReferenceList]()
        let managedContext = appDelegate.managedObjectContext!

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReferenceList")
        let fetchResults = try? managedContext.fetch(fetchRequest)
        
        if(fetchResults?.count == 0)
        {
            return
        }
        
        if let results = fetchResults
        {
            for index in 0...results.count - 1
            {
                let referenceObject: NSManagedObject = results[index] as! NSManagedObject
                referenceLists.append(ReferenceList(reference: referenceObject, context: managedContext))
            }
        }
        
        referenceLists.sorted(by: { $0.getLowercaseName() < $1.getLowercaseName()})
        
        self.tableView.reloadData()
    }
    
    @IBAction func addReferenceList(_ sender: UIBarButtonItem)
    {
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "ReferenceList", in: managedContext)
        let referenceList = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        referenceList.setValue("New Reference List", forKey: "name")
        referenceList.setValue(UUID().uuidString, forKey: "id")
        
        try? managedContext.save()
        addingList = true
        getReferences()
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if(tableView.isDragging)
        {
            CellSlideInTop.animate(cell)
        }
        
        if(addingList)
        {
            let path = IndexPath(row: referenceLists.count - 1, section: 0)
            self.tableView.scrollToRow(at: path, at: UITableViewScrollPosition.top, animated: true)
            
            if((indexPath as NSIndexPath).row == referenceLists.count - 1)
            {
                CellSlideInTop.animate(cell)
                addingList = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        if(segue.identifier == "ShowReferenceList")
        {
            let referenceListView: ReferenceListView = segue.destination as! ReferenceListView
            referenceListView.referenceList = referenceLists[selected]
            referenceListView.animateList = true
        }
        else if(segue.identifier == "ShowPDF")
        {
            let pdfController: PDFViewController = segue.destination as! PDFViewController
            pdfController.referenceList = referenceLists[selected]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: ReferenceListCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ReferenceListCell
        cell.title.text = self.referenceLists[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selected = (indexPath as NSIndexPath).row
        tableView.cellForRow(at: indexPath)?.isSelected = false
        showHint = true
        
        self.performSegue(withIdentifier: "ShowReferenceList", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.register(ReferenceListCell.self, forCellReuseIdentifier: "cell")
        self.title = "EasyReference"
    }
}

