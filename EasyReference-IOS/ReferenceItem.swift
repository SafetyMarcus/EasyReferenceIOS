//
//  ReferenceItem.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation

class ReferenceItem
{
    enum ReferenceType
    {
        case Book
        case Journal
        case BookChapter
        case WebPage
    }
    
    var type: ReferenceType
    var author: String = ""
    var date: String = ""
    var title: String = ""
    var subTitle: String = ""
    var location: String = ""
    var publisher: String = ""
    
    init(type: ReferenceType)
    {
        self.type = type
    }
    
    func getReferenceString() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += getTitleForReference()
        fullString += getSubtitleForReference()
        fullString += getLocationForReference()
        fullString += getPublisherForReference()
        
        return fullString
    }
    
    func getNumberOfCells() -> NSInteger
    {
        var cellCount = 0
        
        if(self.type == ReferenceType.Book)
        {
            cellCount = 6
        }
        
        return cellCount
    }
    
    func getLabelsForCells() -> [NSString]
    {
        var labels: [NSString] = [NSString]()
        
        if(self.type == ReferenceType.Book)
        {
            labels = self.getBookLabels()
        }
        
        return labels
    }
    
    private func getBookLabels() -> [NSString]
    {
        var labels: [NSString] = [NSString]()
        
        labels.append("Author")
        labels.append("Date")
        labels.append("Title")
        labels.append("Subtitle")
        labels.append("Publisher")
        labels.append("Location")
        
        return labels
    }
    
    func getHintsForCells() -> [NSString]
    {
        var hints: [NSString] = [NSString]()
        
        if(self.type == ReferenceType.Book)
        {
            hints = self.getBookHints()
        }
        
        return hints
    }
    
    private func getBookHints() -> [NSString]
    {
        var hints: [NSString] = [NSString]()
        
        hints.append("enter author")
        hints.append("enter date")
        hints.append("enter title")
        hints.append("enter subtitle")
        hints.append("enter publisher")
        hints.append("enter location")
        
        return hints
    }
    
    func getValueForPosition(position: NSInteger) -> NSString
    {
        var value = ""
        
        if(type == ReferenceType.Book)
        {
            value = getBookValueForPosition(position)
        }
        
        return value
    }
    
    private func getBookValueForPosition(position: NSInteger) -> NSString
    {
        if(position == 0)
        {
            return self.author
        }
        else if(position == 1)
        {
            return self.date
        }
        else if(position == 2)
        {
            return self.title
        }
        else if(position == 3)
        {
            return self.subTitle
        }
        else if(position == 4)
        {
            return self.publisher
        }
        else if(position == 5)
        {
            return self.location
        }
        
        return ""
    }
    
    func saveValueForPosition(position: NSInteger, value: NSString)
    {
        if(type == ReferenceType.Book)
        {
            saveBookValueForPosition(position, value: value)
        }
    }
    
    private func saveBookValueForPosition(position: NSInteger, value: NSString)
    {
        if(position == 0)
        {
            self.author = value
        }
        else if(position == 1)
        {
            self.date = value
        }
        else if(position == 2)
        {
            self.title = value
        }
        else if(position == 3)
        {
            self.subTitle = value
        }
        else if(position == 4)
        {
            self.publisher = value
        }
        else if(position == 5)
        {
            self.location = value
        }

    }
    
    func getAuthorForReference() -> String
    {
        if(author.isEmpty)
        {
            return ""
        }
        
        return author
    }
    
    func getDateForReference() -> String
    {
        if(date.isEmpty)
        {
            return ""
        }
        
        return " (\(date))."
    }
    
    func getTitleForReference() -> String
    {
        if(title.isEmpty)
        {
            return ""
        }
        
        return " \(title)"
    }
    
    func getSubtitleForReference() -> String
    {
        if(subTitle.isEmpty)
        {
            return ""
        }
        
        return ": \(subTitle)."
    }
    
    func getLocationForReference() -> String
    {
        if(location.isEmpty)
        {
            return ""
        }
        
        return " \(location)"
    }
    
    func getPublisherForReference() -> String
    {
        if(publisher.isEmpty)
        {
            return ""
        }
        
        return ": \(publisher)"
    }
}