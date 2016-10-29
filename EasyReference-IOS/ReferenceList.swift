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
    fileprivate var references: [ReferenceItem] = []
    
    init()
    {
    }
    
    init(reference: NSManagedObject, context: NSManagedObjectContext)
    {
        self.id = reference.value(forKey: "id") as! String
        self.name = reference.value(forKey: "name") as! String
        
        getAllReferences(context)
    }
    
    func getLowercaseName() -> String
    {
        return name.lowercased()
    }
    
    fileprivate func getAllReferences(_ context: NSManagedObjectContext)
    {
        references = [ReferenceItem]()
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReferenceItem")
        let predicate = NSPredicate(format: "parent_id == %@", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest)
        if(fetchResults == nil || fetchResults?.count == 0)
        {
            return
        }
        
        if let results = fetchResults
        {
            for index in 0...results.count - 1
            {
                let referenceObject: NSManagedObject = results[index] as! NSManagedObject
                references.append(ReferenceItem(referenceItem: referenceObject))
            }
        }
        
        getReferences()
    }
    
    func getReferences() -> [ReferenceItem]
    {
        references.sorted(by: {$0.author < $1.author})
        return references
    }
    
    func addReference(_ reference: ReferenceItem)
    {
        references.append(reference)
    }
    
    func getReferenceText() -> String
    {
        var reference = ""
        
        for index in 0...references.count - 1
        {
            reference = "\(reference)\n\(references[index].getReferenceString())"
        }
        return reference
    }
    
    func deleteReference(_ context: NSManagedObjectContext, row: NSInteger)
    {
        references[row].delete(context)
        references.remove(at: row)
    }
    
    func saveList(_ context: NSManagedObjectContext)
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
    
    func save(_ context: NSManagedObjectContext)
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReferenceList")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest)
        if(fetchResults == nil || fetchResults?.count == 0)
        {
            return
        }
        
        if let results = fetchResults
        {
            if(results.count > 0)
            {
                let referenceList: AnyObject = results[0] as AnyObject
                referenceList.setValue(id, forKey: "id")
                referenceList.setValue(name, forKey: "name")
            }
        }
    }
}
