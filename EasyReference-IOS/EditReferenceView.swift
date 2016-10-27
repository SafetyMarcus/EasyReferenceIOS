//
//  EditReferenceView.swift
//  EasyReference-IOS
//
//  Created by Marcus on 1/03/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

protocol AddAuthorDelegate
{
    func addAuthor(_ firstName: NSString, middleName: NSString, lastName: NSString)
}

protocol AddAuthorListener
{
    func clickedAddAuthor()
}

class EditReferenceView: UITableViewController, AddAuthorDelegate, AddAuthorListener, UITextFieldDelegate
{
    var referenceItem: ReferenceItem! = nil
    var saveReferenceDelegate: SaveReferenceDelegate! = nil
    var animateIn = false
    
    @IBAction func unwindToEditReference(_ unwindSegue: UIStoryboardSegue){}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: "EditReferenceAuthorCell", bundle: nil), forCellReuseIdentifier: "authorCell")
        self.tableView.register(UINib(nibName: "EditReferenceCell", bundle: nil), forCellReuseIdentifier: "referenceCell")
    }
    
    func save()
    {
        referenceItem.save((UIApplication.shared.delegate as! AppDelegate).managedObjectContext!)
        saveReferenceDelegate.saveReference(referenceItem)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return referenceItem.getNumberOfCells()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if((indexPath as NSIndexPath).row == 0)
        {
            let cell: EditReferenceAuthorCell = self.tableView.dequeueReusableCell(withIdentifier: "authorCell") as! EditReferenceAuthorCell
            cell.referenceText.text = referenceItem.author
            cell.delegate = self
            cell.referenceText.delegate = self
            cell.referenceText.returnKeyType = .done
            
            if((referenceItem.author as NSString).length > 0)
            {
                cell.referenceText.isEnabled = true
            }
            else
            {
                cell.referenceText.isEnabled = false
            }
            
            return cell
        }
        else
        {
            let cell: EditReferenceCell = self.tableView.dequeueReusableCell(withIdentifier: "referenceCell") as! EditReferenceCell
            cell.referenceLabel.text = referenceItem.getLabelsForCells()[(indexPath as NSIndexPath).row]
            cell.referenceText.placeholder = referenceItem.getHintsForCells()[(indexPath as NSIndexPath).row]
            cell.referenceText.text = referenceItem.getValueForPosition((indexPath as NSIndexPath).row)
            cell.referenceText.delegate = self
            cell.referenceText.returnKeyType = .done
            cell.referenceText.autocapitalizationType = referenceItem.getTextInputForCell((indexPath as NSIndexPath).row)
            
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if(animateIn)
        {
            animateIn = false
            tableView.reloadData()
        
            let cells = tableView.visibleCells
            let tableWidth: CGFloat = tableView.bounds.size.width
        
            for i in cells
            {
                let cell: UITableViewCell = i
                cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
            }
        
            var index = 0
        
            for a in cells
            {
                let cell: UITableViewCell = a
                UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0);},
                    completion: nil)
                
                index += 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        save()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString replacement: String) -> Bool
    {
        let original = NSString(string: textField.text!).substring(with: range)
        let new = replacement
        if(original != new)
        {
            let cell: UITableViewCell = textField.superview?.superview as! UITableViewCell
            
            let row: IndexPath = (self.tableView.indexPath(for: cell) as IndexPath?)!
            let position = (row as NSIndexPath).row
            
            let textFieldText: NSString = NSString(string: textField.text!)
            var total = "\(textFieldText.substring(to: range.location))"
            total += "\(replacement)"
            total += "\(textFieldText.substring(from: range.location + range.length))"
            
            referenceItem.saveValueForPosition(position, value: total)

            return true
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func getLabelForPosition(_ position: NSInteger) -> String
    {
        return referenceItem.getLabelsForCells()[position]
    }
    
    func clickedAddAuthor()
    {
        performSegue(withIdentifier: "ShowAddAuthor", sender: self)
    }
    
    func addAuthor(_ firstName: NSString, middleName: NSString, lastName: NSString)
    {
        let authorCell: EditReferenceAuthorCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EditReferenceAuthorCell
        var authors = ""
        
        if((referenceItem.author as NSString).length > 0)
        {
            authors = referenceItem.author.replacingOccurrences(of: " &", with: "")
            authors = "\(authors), & "
        }
        
        if(lastName.length > 0)
        {
            authors += "\(lastName.substring(to: 1).uppercased())\(lastName.substring(from: 1)), "
        }
        
        if(firstName.length > 0)
        {
            authors += "\(firstName.substring(to: 1).uppercased())."
        }
        
        if(middleName.length > 0)
        {
            authors += " \(middleName.substring(to: 1).uppercased())."
        }
        
        authorCell.referenceText.text = authors
        
        if((authors as NSString).length > 0)
        {
            authorCell.referenceText.isEnabled = true
        }

        referenceItem.saveValueForPosition(0, value: authors)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "ShowAddAuthor")
        {
            let addAuthorView: AddAuthorViewController = (segue.destination as! UINavigationController).topViewController as! AddAuthorViewController
            addAuthorView.addAuthorDelegate = self
        }
    }
}
