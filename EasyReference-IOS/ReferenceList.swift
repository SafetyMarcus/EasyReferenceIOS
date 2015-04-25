//
//  ReferenceList.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import CoreData
import Foundation

class ReferenceList
{
    var id = ""
    var name = ""
    var references: [ReferenceItem] = []
    
    init()
    {
    }
    
    init(reference: NSManagedObject, context: NSManagedObjectContext)
    {
        self.id = reference.valueForKey("id") as! String
        self.name = reference.valueForKey("name") as! String
        
        getAllReferences(context)
    }
    
    func getAllReferences(context: NSManagedObjectContext)
    {
        references = [ReferenceItem]()
        
        var error : NSError?
        let fetchRequest = NSFetchRequest(entityName: "ReferenceItem")
        let predicate = NSPredicate(format: "parent_id == %@", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = context.executeFetchRequest(fetchRequest, error: &error)
        if(fetchResults == nil || fetchResults?.count == 0)
        {
            return
        }
        
        if let results = fetchResults
        {
            for index in 0...results.count - 1
            {
                var referenceObject: NSManagedObject = results[index] as! NSManagedObject
                references.append(ReferenceItem(referenceItem: referenceObject))
            }
        }
    }
    
    func deleteReference(context: NSManagedObjectContext, row: NSInteger)
    {
        references[row].delete(context)
        references.removeAtIndex(row)
    }
    
    func saveList(context: NSManagedObjectContext)
    {
        if(references.isEmpty)
        {
            return
        }
        
        for i in 0...references.count - 1
        {
            references[i].save(context)
        }
    }
    
    func save(context: NSManagedObjectContext)
    {
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "ReferenceList")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = context.executeFetchRequest(fetchRequest, error: &error)
        if(fetchResults == nil || fetchResults?.count == 0)
        {
            return
        }
        
        if let results = fetchResults
        {
            if(results.count > 0)
            {
                var referenceList: AnyObject = results[0]
                referenceList.setValue(id, forKey: "id")
                referenceList.setValue(name, forKey: "name")
            }
        }
    }
}