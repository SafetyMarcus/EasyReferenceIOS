//
//  ReferenceItem.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import CoreData

class ReferenceItem
{
    enum ReferenceType
    {
        case Book
        case Journal
        case BookChapter
        case WebPage
    }
    
    var id: String
    var parentId: String
    
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
    
    //Book Chapter Values
    var editors = ""
    var bookTitle = ""
    var bookSubtitle = ""
    
    //Web page
    var url = ""
    
    init(parentId: String, type: ReferenceType)
    {
        self.id = NSUUID().UUIDString
        self.parentId = parentId
        self.type = type
    }
    
    init(referenceItem: NSManagedObject)
    {
        self.id = referenceItem.valueForKey("id") as! String
        self.parentId = referenceItem.valueForKey("parent_id") as! String
        
        var typeInt = referenceItem.valueForKey("type") as! NSInteger
        self.type = ReferenceType.Book
        
        self.author = referenceItem.valueForKey("author") as! String
        self.date = referenceItem.valueForKey("date") as! String
        self.title = referenceItem.valueForKey("title") as! String
        self.subTitle = referenceItem.valueForKey("subtitle") as! String
        
        self.location = referenceItem.valueForKey("location") as! String
        self.publisher = referenceItem.valueForKey("publisher") as! String
        
        self.journalTitle = referenceItem.valueForKey("journal_title") as! String
        self.volumeNumber = referenceItem.valueForKey("volume_number") as! String
        self.issueNumber = referenceItem.valueForKey("issue_number") as! String
        self.pageNumber = referenceItem.valueForKey("page_number") as! String
        self.doi = referenceItem.valueForKey("doi") as! String
        
        self.editors = referenceItem.valueForKey("editors") as! String
        self.bookTitle = referenceItem.valueForKey("book_title") as! String
        self.bookSubtitle = referenceItem.valueForKey("book_subtitle") as! String
        
        self.url = referenceItem.valueForKey("url") as! String
        
        type = getTypeForInt(typeInt)
    }
    
    func save(context: NSManagedObjectContext)
    {
        let entity = NSEntityDescription.entityForName("ReferenceItem", inManagedObjectContext: context)
        let predicate = NSPredicate(format: "id == %@", id)

        let fetchRequest = NSFetchRequest(entityName: "ReferenceItem")
        fetchRequest.predicate = predicate
        
        var error: NSError?
        let fetchResults = context.executeFetchRequest(fetchRequest, error: &error)

        var referenceItem: NSManagedObject?
        
        if let results = fetchResults
        {
            if(fetchResults?.count > 0)
            {
                referenceItem = results[0] as? NSManagedObject
            }
        }
        
        if(referenceItem == nil)
        {
            referenceItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        }
        
        saveToCoreData(referenceItem!)
    }
    
    private func saveToCoreData(reference: NSManagedObject)
    {
        reference.setValue(id, forKey: "id")
        reference.setValue(parentId, forKey: "parent_id")
        
        reference.setValue(getIntForType(type), forKey: "type")
        
        reference.setValue(author, forKey: "author")
        reference.setValue(date, forKey: "date")
        reference.setValue(title, forKey: "title")
        reference.setValue(subTitle, forKey: "subtitle")

        reference.setValue(publisher, forKey: "publisher")
        reference.setValue(location, forKey: "location")
        
        reference.setValue(journalTitle, forKey: "journal_title")
        reference.setValue(volumeNumber, forKey: "volume_number")
        reference.setValue(issueNumber, forKey: "issue_number")
        reference.setValue(pageNumber, forKey: "page_number")
        reference.setValue(doi, forKey: "doi")
        
        reference.setValue(editors, forKey: "editors")
        reference.setValue(bookTitle, forKey: "book_title")
        reference.setValue(bookSubtitle, forKey: "book_subtitle")
        
        reference.setValue(url, forKey: "url")
    }
    
    func getTypeForInt(int: NSInteger) -> ReferenceType
    {
        if(int == 0)
        {
            return ReferenceType.Book
        }
        else if(int == 1)
        {
            return ReferenceType.Journal
        }
        else if(int == 2)
        {
            return ReferenceType.BookChapter
        }
        else if(int == 3)
        {
            return ReferenceType.WebPage
        }
        
        return ReferenceType.Book
    }
    
    func getIntForType(type: ReferenceType) -> NSInteger
    {
        var type = 0
        
        if(self.type == ReferenceType.Book)
        {
            type = 0
        }
        else if(self.type == ReferenceType.Journal)
        {
            type = 1
        }
        else if(self.type == ReferenceType.BookChapter)
        {
            type = 2
        }
        else if(self.type == ReferenceType.WebPage)
        {
            type = 3
        }

        return type
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
        else if(type == ReferenceType.BookChapter)
        {
            return getBookChapterReferenceString()
        }
        else if(type == ReferenceType.WebPage)
        {
            return getWebReferenceString()
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
    
    func getBookChapterReferenceString() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += getTitleForReference()
        fullString += getSubtitleForReference()
        fullString += getEditorsForReference()
        fullString += getBookTitleForReference()
        fullString += getBookSubtitleForReference()
        fullString += getPageNumberForReference()
        fullString += getLocationForReference()
        fullString += getPublisherForReference()
        
        return fullString
    }
    
    func getWebReferenceString() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += getTitleForReference()
        fullString += getUrlForReference()
        
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
    
    func getEditorsForReference() -> String
    {
        if(editors.isEmpty)
        {
            return ""
        }
        
        return " In \(editors) (Eds)"
    }
    
    func getBookTitleForReference() -> String
    {
        if(bookTitle.isEmpty)
        {
            return ""
        }
        
        return " \(bookTitle), "
    }
    
    func getBookSubtitleForReference() -> String
    {
        if(bookSubtitle.isEmpty)
        {
            return ""
        }
        
        return " \(bookSubtitle), "
    }
    
    func getUrlForReference() -> String
    {
        if(url.isEmpty)
        {
            return ""
        }
        
        return " Retrieved from \(url)"
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
        else if(self.type == ReferenceType.BookChapter)
        {
            cellCount = 10
        }
        else if(self.type == ReferenceType.WebPage)
        {
            cellCount = 4;
        }
        
        return cellCount
    }
    
    func getLabelsForCells() -> [String]
    {
        var labels = [String]()
        
        if(self.type == ReferenceType.Book)
        {
            labels = self.getBookLabels()
        }
        else if(self.type == ReferenceType.Journal)
        {
            labels = self.getJournalLabels()
        }
        else if(self.type == ReferenceType.BookChapter)
        {
            labels = self.getBookChapterLabels()
        }
        else if(self.type == ReferenceType.WebPage)
        {
            labels = self.getWebLabels()
        }
        
        return labels
    }
    
    private func getBookLabels() -> [String]
    {
        var labels = [String]()
        
        labels.append("Author")
        labels.append("Year")
        labels.append("Title")
        labels.append("Subtitle")
        labels.append("Location")
        labels.append("Publisher")
        
        return labels
    }
    
    private func getJournalLabels() -> [String]
    {
        var labels = [String]()
        
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
    
    private func getBookChapterLabels() -> [String]
    {
        var labels = [String]()
        
        labels.append("Author")
        labels.append("Year")
        labels.append("Chapter Title")
        labels.append("Chapter Subtitle")
        labels.append("Editors")
        labels.append("Book Title")
        labels.append("Book Subtitle")
        labels.append("Pages of Chapter")
        labels.append("Location")
        labels.append("Publisher")
        
        return labels
    }
    
    private func getWebLabels() -> [String]
    {
        var labels = [String]()
        
        labels.append("Author")
        labels.append("Year")
        labels.append("Title")
        labels.append("URL")
        
        return labels
    }
    
    func getHintsForCells() -> [String]
    {
        var hints = [String]()
        
        if(self.type == ReferenceType.Book)
        {
            hints = self.getBookHints()
        }
        else if(self.type == ReferenceType.Journal)
        {
            hints = self.getJournalHints()
        }
        else if(self.type == ReferenceType.BookChapter)
        {
            hints = self.getBookChapterHints()
        }
        else if(self.type == ReferenceType.WebPage)
        {
            hints = self.getWebHints()
        }
        
        return hints
    }
    
    private func getBookHints() -> [String]
    {
        var hints = [String]()
        
        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter title")
        hints.append("enter subtitle")
        hints.append("enter location")
        hints.append("enter publisher")
        
        return hints
    }

    private func getJournalHints() -> [String]
    {
        var hints = [String]()
        
        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter title")
        hints.append("enter subtitle")
        hints.append("enter journal title")
        hints.append("enter volume number")
        hints.append("enter issue number")
        hints.append("enter page number")
        hints.append("enter doi/url")
        
        return hints
    }
    
    private func getBookChapterHints() -> [String]
    {
        var hints = [String]()

        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter chapter title")
        hints.append("enter chapter subtitle")
        hints.append("enter editors")
        hints.append("enter book title")
        hints.append("enter book subtitle")
        hints.append("enter pages of chapter")
        hints.append("enter location")
        hints.append("enter publisher")
        
        return hints
    }
    
    private func getWebHints() -> [String]
    {
        var hints = [String]()
        
        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter chapter title")
        hints.append("enter url")
        
        return hints
    }
    
    func getValueForPosition(position: NSInteger) -> String
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
        else if(type == ReferenceType.BookChapter)
        {
            value = getBookChapterValueForPosition(position)
        }
        else if(type == ReferenceType.WebPage)
        {
            value = getWebValueForPosition(position)
        }
        
        return value
    }
    
    private func getBookValueForPosition(position: NSInteger) -> String
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
            return self.location
        }
        else if(position == 5)
        {
            return self.publisher
        }
        
        return ""
    }
    
    private func getJournalValueForPosition(position: NSInteger) -> String
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
        else if(position == 7)
        {
            return self.pageNumber
        }
        else if(position == 8)
        {
            return self.doi
        }
        
        return ""
    }
    
    private func getBookChapterValueForPosition(position: NSInteger) -> String
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
            return self.editors
        }
        else if(position == 5)
        {
            return self.bookTitle
        }
        else if(position == 6)
        {
            return self.bookSubtitle
        }
        else if(position == 7)
        {
            return self.pageNumber
        }
        else if(position == 8)
        {
            return self.location
        }
        else if(position == 9)
        {
            return self.publisher
        }
        
        return ""
    }
    
    func getWebValueForPosition(position: NSInteger) -> String
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
            return self.url
        }
        
        return ""
    }
    
    func saveValueForPosition(position: NSInteger, value: String)
    {
        if(type == ReferenceType.Book)
        {
            saveBookValueForPosition(position, value: value)
        }
        else if(type == ReferenceType.Journal)
        {
            saveJournalValueForPosition(position, value: value)
        }
        else if(type == ReferenceType.BookChapter)
        {
            saveBookChapterValueForPosition(position, value: value)
        }
        else if(type == ReferenceType.WebPage)
        {
            saveWebReferenceValueForPosition(position, value: value)
        }
    }
    
    private func saveBookValueForPosition(position: NSInteger, value: String)
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
            self.location = value
        }
        else if(position == 5)
        {
            self.publisher = value
        }
    }
    
    private func saveJournalValueForPosition(position: NSInteger, value: String)
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
    
    private func saveBookChapterValueForPosition(position: NSInteger, value: String)
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
            self.editors = value
        }
        else if(position == 5)
        {
            self.bookTitle = value
        }
        else if(position == 6)
        {
            self.bookSubtitle = value
        }
        else if(position == 7)
        {
            self.pageNumber = value
        }
        else if(position == 8)
        {
            self.location = value
        }
        else if(position == 9)
        {
            self.publisher = value
        }
    }
    
    private func saveWebReferenceValueForPosition(position: NSInteger, value: String)
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
            self.url = value
        }
    }
}