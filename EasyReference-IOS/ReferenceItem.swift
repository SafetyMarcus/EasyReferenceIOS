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