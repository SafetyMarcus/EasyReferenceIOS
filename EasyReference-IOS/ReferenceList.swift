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
    
    init(reference: NSManagedObject, NSManagedObjectContext)
    {
        self.id = reference.valueForKey("id") as! String
        self.name = reference.valueForKey("name") as! String
    }
    
    func getAllReferences(context: NSManagedObjectContext)
    {
        var error : NSError?
        let fetchRequest = NSFetchRequest(entityName: "ReferenceItem")
        let fetchResults = context.executeFetchRequest(fetchRequest, error: &error)
        
        if(fetchResults?.count == 0)
        {
            return
        }
        
        if let results = fetchResults
        {
            for index in 0...results.count - 1
            {
                var referenceObject: NSManagedObject = results[index] as! NSManagedObject
                
                var parentId = referenceObject.valueForKey("parentId") as! String
                if(parentId == self.id)
                {
                    references.append(ReferenceItem(referenceItem: referenceObject))
                }
            }
        }
    }
}