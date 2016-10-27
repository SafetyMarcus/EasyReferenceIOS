//
//  ReferenceListView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 1/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

protocol SaveReferenceDelegate
{
    func saveReference(_ reference: ReferenceItem)
}
protocol AddReferenceDelegate
{
    func addReference(_ type: ReferenceItem.ReferenceType)
}

class ReferenceListView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, SaveReferenceDelegate, AddReferenceDelegate, ShowingDelegate
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var referenceList = ReferenceList()
    var selected = 0
    var stretchyHeader = UIView()
    var animateList = false
    var didAddReference = false
    
    var showHint = false
    var hintCell: ReferenceListCell!
    
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptySubtitle: UILabel!
    
    @IBOutlet
    var tableView: UITableView!
    
    func addReference(_ type: ReferenceItem.ReferenceType)
    {
        let newReference = ReferenceItem(parentId: referenceList.id, type: type)
        
        referenceList.addReference(newReference)
        referenceList.saveList(appDelegate.managedObjectContext!)
        self.tableView.reloadData()
        
        selected = (referenceList.getReferences() as NSArray).index(of: newReference)
        didAddReference = true
    }
    
    @IBAction func unwindToList(_ unwindSegue: UIStoryboardSegue){}
    
    override func viewWillAppear(_ animated: Bool)
    {
        if(animateList)
        {
            animateList = false
            tableView.reloadData()
        
            let cells = tableView.visibleCells
            let tableHeight: CGFloat = tableView.bounds.size.height
        
            for i in cells
            {
                if let cell: UITableViewCell = i as? ReferenceListCell
                {
                    cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
                }
            }
        
            var index = 0
        
            for a in cells
            {
                if let cell: ReferenceListCell = a as? ReferenceListCell
                {
                    UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0);},
                        completion: nil)
            
                    index += 1
                }
            }
        }
    }
    
    func showDeleteHint()
    {
        let view = self.navigationController?.view
        let shadow = Shadow(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: view!.frame.height))
        shadow.finishDelegate = self
        view!.addSubview(shadow)
        
        hintCell.showHint()
    }
    
    func finishedShowing()
    {
        hintCell.hideHint()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let headerCell: ReferenceListHeaderCell = self.tableView.cellForRow(at: indexPath) as! ReferenceListHeaderCell

        referenceList.name = headerCell.title.text!
        referenceList.save(appDelegate.managedObjectContext!)
        appDelegate.saveContext()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        stretchyHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 4))
        stretchyHeader.backgroundColor = UIColor.red
        
        tableView.addSubview(stretchyHeader)
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -60)
        
        self.tableView.register(ReferenceListCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "ReferenceListHeaderCell", bundle: nil), forCellReuseIdentifier: "ReferenceListHeader")
        self.title = referenceList.name
        appDelegate.saveContext()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if(didAddReference)
        {
            didAddReference = false
            performSegue(withIdentifier: "ShowReferenceItem", sender: self.tableView)
        }
        
        if(showHint && !appDelegate.seenReferenceHint)
        {
            appDelegate.seenReferenceHint = true
            appDelegate.saveSettings()
            
            showHint = false
            showDeleteHint()
        }
    }

    func updateStretchyHeader()
    {
        var stretchyRect = CGRect(x: 0, y: -4, width: self.tableView.bounds.width, height: 4)
        if(self.tableView.contentOffset.y < -4)
        {
            stretchyRect.origin.y = self.tableView.contentOffset.y
            stretchyRect.size.height = -tableView.contentOffset.y
        }
        
        self.stretchyHeader.frame = stretchyRect
    }
    
    func saveReference(_ reference: ReferenceItem)
    {
        showHint = true
        var references = referenceList.getReferences()
        references[selected] = reference
        referenceList.saveList(appDelegate.managedObjectContext!)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "ShowReferenceItem")
        {
            self.navigationItem.title = "Save"
            let editReferenceView: EditReferenceView = (segue.destination as! UINavigationController).topViewController as! EditReferenceView
            var references = referenceList.getReferences()
            editReferenceView.referenceItem = references[selected]
            editReferenceView.animateIn = true
            editReferenceView.saveReferenceDelegate = self
        }
        else if(segue.identifier == "SelectReferenceType")
        {
            self.navigationItem.title = "Cancel"
            let referenceTypeView: SelectReferenceTypeViewController = (segue.destination as! UINavigationController) as! SelectReferenceTypeViewController
            referenceTypeView.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if((indexPath as NSIndexPath).row > 0)
        {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            referenceList.deleteReference(appDelegate.managedObjectContext!, row: (indexPath as NSIndexPath).row - 1)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    private func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]?
    {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete") { (UITableViewRowAction, indexPath: IndexPath!) -> Void in
                self.referenceList.deleteReference(self.appDelegate.managedObjectContext!, row: indexPath.row - 1)
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((indexPath as NSIndexPath).row == 0)
        {
            return 60
        }

        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width - 40, height: 9999))
        
        var references = referenceList.getReferences()
        let currentReference = references[(indexPath as NSIndexPath).row - 1]
        var labelText = currentReference.getReferenceString()
        
        if(labelText.isEmpty)
        {
            labelText = "Click to edit!"
        }
        
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        
        label.text = labelText
        label.sizeToFit()
        
        var size = label.frame.height + 20
        if(size < 60)
        {
            size = 60
        }
        
        return size
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int
    {
        let references = referenceList.getReferences()
        let count = references.count + 1;
        
        if(count <= 1)
        {
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.emptyTitle.alpha = 1
                self.emptySubtitle.alpha = 1
            })
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.emptyTitle.alpha = 0
                self.emptySubtitle.alpha = 0
            })
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        selected = (indexPath as NSIndexPath).row - 1
        
        if(selected != -1)
        {
            performSegue(withIdentifier: "ShowReferenceItem", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
       updateStretchyHeader()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        updateStretchyHeader()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if((indexPath as NSIndexPath).row == 0)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReferenceListHeader") as! ReferenceListHeaderCell
            cell.title.text = referenceList.name
            cell.title.returnKeyType = .done
            cell.title.delegate = self
            cell.title.autocapitalizationType = .words
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
        else
        {
            let cell: ReferenceListCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ReferenceListCell
            
            var references = referenceList.getReferences()
            let currentReference = references[(indexPath as NSIndexPath).row - 1]
            var labelText = currentReference.getReferenceString()
        
            if(labelText.isEmpty)
            {
                labelText = "Click to edit!"
            }
        
            cell.title.text = labelText
            
            if(showHint && hintCell == nil)
            {
                hintCell = cell
            }
            
            return cell
        }
    }
}
