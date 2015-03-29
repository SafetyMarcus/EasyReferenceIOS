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
    var author = ""
    var date = ""
    var title = ""
    var subTitle = ""
    
    //Book values
    var location = ""
    var publisher = ""
    
    //Journal values
    var journalTitle = ""
    var volumeNumber = ""
    var issueNumber = ""
    var pageNumber = ""
    var doi = ""
    
    init(type: ReferenceType)
    {
        self.type = type
    }
    
    func getReferenceString() -> String
    {
        if(type == ReferenceType.Book)
        {
            return getBookReferenceString()
        }
        else if(type == ReferenceType.Journal)
        {
            return getJournalReferenceString()
        }
        
        return ""
    }
    
    func getBookReferenceString() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += getTitleForReference()
        fullString += getSubtitleForReference()
        fullString += getLocationForReference()
        fullString += getPublisherForReference()
        
        return fullString
    }
    
    func getJournalReferenceString() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += getTitleForReference()
        fullString += getSubtitleForReference()
        fullString += getJournalTitleForReference()
        fullString += getVolumeNumberForReference()
        fullString += getIssueNumberForReference()
        fullString += getPageNumberForReference()
        fullString += getDoiForReference()
        
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
    
    func getJournalTitleForReference() -> String
    {
        if(journalTitle.isEmpty)
        {
            return ""
        }
        
        return " \(journalTitle), "
    }
    
    func getVolumeNumberForReference() -> String
    {
        if(volumeNumber.isEmpty)
        {
            return ""
        }
        
        return " \(volumeNumber)"
    }
    
    func getIssueNumberForReference() -> String
    {
        if(issueNumber.isEmpty)
        {
            return ""
        }
        
        return "(\(issueNumber)),"
    }
    
    func getPageNumberForReference() -> String
    {
        if(pageNumber.isEmpty)
        {
            return ""
        }
        
        return " \(pageNumber)."
    }
    
    func getDoiForReference() -> String
    {
        if(doi.isEmpty)
        {
            return ""
        }
        
        return " doi:\(doi)"
    }
    
    func getNumberOfCells() -> NSInteger
    {
        var cellCount = 0
        
        if(self.type == ReferenceType.Book)
        {
            cellCount = 6
        }
        else if(self.type == ReferenceType.Journal)
        {
            cellCount = 9
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
        else if(self.type == ReferenceType.Journal)
        {
            labels = self.getJournalLabels()
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
    
    private func getJournalLabels() -> [NSString]
    {
        var labels: [NSString] = [NSString]()
        
        labels.append("Author")
        labels.append("Year")
        labels.append("Title")
        labels.append("Subtitle")
        labels.append("Journal Title")
        labels.append("Volume No.")
        labels.append("Issue No.")
        labels.append("Page No.")
        labels.append("DOI/URL")
        
        return labels
    }
    
    func getHintsForCells() -> [NSString]
    {
        var hints: [NSString] = [NSString]()
        
        if(self.type == ReferenceType.Book)
        {
            hints = self.getBookHints()
        }
        else if(self.type == ReferenceType.Journal)
        {
            hints = self.getJournalHints()
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

    private func getJournalHints() -> [NSString]
    {
        var hints: [NSString] = [NSString]()
        
        hints.append("enter author")
        hints.append("enter date")
        hints.append("enter title")
        hints.append("enter subtitle")
        hints.append("enter journal title")
        hints.append("enter volume number")
        hints.append("enter issue number")
        hints.append("enter page number")
        hints.append("enter doi/url")
        
        return hints
    }
    
    func getValueForPosition(position: NSInteger) -> NSString
    {
        var value = ""
        
        if(type == ReferenceType.Book)
        {
            value = getBookValueForPosition(position)
        }
        else if(type == ReferenceType.Journal)
        {
            value = getJournalValueForPosition(position)
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
    
    private func getJournalValueForPosition(position: NSInteger) -> NSString
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
            return self.journalTitle
        }
        else if(position == 5)
        {
            return self.volumeNumber
        }
        else if(position == 6)
        {
            return self.issueNumber
        }
        else if(position == 5)
        {
            return self.pageNumber
        }
        else if(position == 5)
        {
            return self.doi
        }
        
        return ""
    }
    
    func saveValueForPosition(position: NSInteger, value: NSString)
    {
        if(type == ReferenceType.Book)
        {
            saveBookValueForPosition(position, value: value)
        }
        else if(type == ReferenceType.Journal)
        {
            saveJournalValueForPosition(position, value: value)
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
    
    private func saveJournalValueForPosition(position: NSInteger, value: NSString)
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
            self.journalTitle = value
        }
        else if(position == 5)
        {
            self.volumeNumber = value
        }
        else if(position == 6)
        {
            self.issueNumber = value
        }
        else if(position == 7)
        {
            self.pageNumber = value
        }
        else if(position == 8)
        {
            self.doi = value
        }
    }
}