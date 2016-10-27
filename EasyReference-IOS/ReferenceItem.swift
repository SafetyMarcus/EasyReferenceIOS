//
//  ReferenceItem.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ReferenceItem
{
    enum ReferenceType
    {
        case book
        case journal
        case bookChapter
        case webPage
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
        self.id = UUID().uuidString
        self.parentId = parentId
        self.type = type
    }
    
    init(referenceItem: NSManagedObject)
    {
        self.id = referenceItem.value(forKey: "id") as! String
        self.parentId = referenceItem.value(forKey: "parent_id") as! String
        
        let typeInt = referenceItem.value(forKey: "type") as! NSInteger
        self.type = ReferenceType.book
        
        self.author = referenceItem.value(forKey: "author") as! String
        self.date = referenceItem.value(forKey: "date") as! String
        self.title = referenceItem.value(forKey: "title") as! String
        self.subTitle = referenceItem.value(forKey: "subtitle") as! String
        
        self.location = referenceItem.value(forKey: "location") as! String
        self.publisher = referenceItem.value(forKey: "publisher") as! String
        
        self.journalTitle = referenceItem.value(forKey: "journal_title") as! String
        self.volumeNumber = referenceItem.value(forKey: "volume_number") as! String
        self.issueNumber = referenceItem.value(forKey: "issue_number") as! String
        self.pageNumber = referenceItem.value(forKey: "page_number") as! String
        self.doi = referenceItem.value(forKey: "doi") as! String
        
        self.editors = referenceItem.value(forKey: "editors") as! String
        self.bookTitle = referenceItem.value(forKey: "book_title") as! String
        self.bookSubtitle = referenceItem.value(forKey: "book_subtitle") as! String
        
        self.url = referenceItem.value(forKey: "url") as! String
        
        type = getTypeForInt(typeInt)
    }
    
    func delete(_ context: NSManagedObjectContext)
    {
        let entity = NSEntityDescription.entity(forEntityName: "ReferenceItem", in: context)
        let predicate = NSPredicate(format: "id == %@", id)
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReferenceItem")
        fetchRequest.predicate = predicate
        
        let fetchResults: [NSManagedObject] = try! (context.fetch(fetchRequest) as? [NSManagedObject])!
        
        let itemToDelete = fetchResults[0]
        context.delete(itemToDelete)
    }
    
    func save(_ context: NSManagedObjectContext)
    {
        let entity = NSEntityDescription.entity(forEntityName: "ReferenceItem", in: context)
        let predicate = NSPredicate(format: "id == %@", id)

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReferenceItem")
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest)

        var referenceItem: NSManagedObject?
        
        if let results = fetchResults
        {
            if((fetchResults?.count)! > 0)
            {
                referenceItem = results[0] as? NSManagedObject
            }
        }
        
        if(referenceItem == nil)
        {
            referenceItem = NSManagedObject(entity: entity!, insertInto: context)
        }
        
        saveToCoreData(referenceItem!)
    }
    
    fileprivate func saveToCoreData(_ reference: NSManagedObject)
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
    
    func getTypeForInt(_ int: NSInteger) -> ReferenceType
    {
        if(int == 0)
        {
            return ReferenceType.book
        }
        else if(int == 1)
        {
            return ReferenceType.journal
        }
        else if(int == 2)
        {
            return ReferenceType.bookChapter
        }
        else if(int == 3)
        {
            return ReferenceType.webPage
        }
        
        return ReferenceType.book
    }
    
    func getIntForType(_ type: ReferenceType) -> NSInteger
    {
        var type = 0
        
        if(self.type == ReferenceType.book)
        {
            type = 0
        }
        else if(self.type == ReferenceType.journal)
        {
            type = 1
        }
        else if(self.type == ReferenceType.bookChapter)
        {
            type = 2
        }
        else if(self.type == ReferenceType.webPage)
        {
            type = 3
        }

        return type
    }
    
    func getHtmlReferenceString() -> String
    {
        if(type == ReferenceType.book)
        {
            return getHtmlBookReference()
        }
        else if(type == ReferenceType.journal)
        {
            return getHtmlJournalReference()
        }
        else if(type == ReferenceType.bookChapter)
        {
            return getHtmlBookChapterReference()
        }
        else if(type == ReferenceType.webPage)
        {
            return getHtmlWebReference()
        }
        
        return getReferenceString()
    }
    
    fileprivate func getHtmlBookReference() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += "<i>"
        fullString += getTitleForReference()
        fullString += getSubtitleForReference()
        fullString += "</i>"
        fullString += getLocationForReference()
        fullString += getPublisherForReference()
        
        return fullString
    }
    
    fileprivate func getHtmlJournalReference() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += getTitleForReference()
        fullString += getSubtitleForReference()
        fullString += "<i>"
        fullString += getJournalTitleForReference()
        fullString += getVolumeNumberForReference()
        fullString += "</i>"
        fullString += getIssueNumberForReference()
        fullString += getPageNumberForReference()
        fullString += getDoiForReference()
        
        return fullString
    }
    
    fileprivate func getHtmlBookChapterReference() -> String
    {
        var fullString = getAuthorForReference()
        fullString += getDateForReference()
        fullString += getTitleForReference()
        fullString += getSubtitleForReference()
        fullString += getEditorsForReference()
        fullString += "<i>"
        fullString += getBookTitleForReference()
        fullString += getBookSubtitleForReference()
        fullString += "</i>"
        fullString += getPageNumberForReference()
        fullString += getLocationForReference()
        fullString += getPublisherForReference()
        
        return fullString
    }
    
    fileprivate func getHtmlWebReference() -> String
    {
        var italicize = false
        if(getReferenceString().range(of: ".html") == nil)
        {
            italicize = true
        }
        
        var fullString = getAuthorForReference()
        
        fullString += getDateForReference()
        if italicize
        {
            fullString += "<i>"
        }
        
        fullString += getTitleForReference()
        
        if italicize
        {
            fullString += "</i>"
        }
        
        fullString += getUrlForReference()
        
        return fullString
    }

    
    func getReferenceString() -> String
    {
        if(type == ReferenceType.book)
        {
            return getBookReferenceString()
        }
        else if(type == ReferenceType.journal)
        {
            return getJournalReferenceString()
        }
        else if(type == ReferenceType.bookChapter)
        {
            return getBookChapterReferenceString()
        }
        else if(type == ReferenceType.webPage)
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
        
        return getCapitalisedString(author)
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
        
        return " \(getCapitalisedString(title))"
    }
    
    func getSubtitleForReference() -> String
    {
        if(subTitle.isEmpty)
        {
            return ""
        }
        
        return ": \(getCapitalisedString(subTitle))."
    }
    
    func getLocationForReference() -> String
    {
        if(location.isEmpty)
        {
            return ""
        }
        
        return " \(getCapitalisedString(location))"
    }
    
    func getPublisherForReference() -> String
    {
        if(publisher.isEmpty)
        {
            return ""
        }
        
        return ": \(getCapitalisedString(publisher))"
    }
    
    func getJournalTitleForReference() -> String
    {
        if(journalTitle.isEmpty)
        {
            return ""
        }
        
        return " \(getCapitalisedString(journalTitle)), "
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
        
        return " \(getCapitalisedString(bookTitle)), "
    }
    
    func getBookSubtitleForReference() -> String
    {
        if(bookSubtitle.isEmpty)
        {
            return ""
        }
        
        return " \(getCapitalisedString(bookSubtitle)), "
    }
    
    func getUrlForReference() -> String
    {
        if(url.isEmpty)
        {
            return ""
        }
        
        return " Retrieved from \(url)"
    }
    
    fileprivate func getCapitalisedString(_ stringToCapitalise: String) -> String
    {
        var start: String = (stringToCapitalise as NSString).substring(to: 1)
        start = start.capitalized
        
        let end = (stringToCapitalise as NSString).substring(from: 1)
        let result = "\(start)\(end)"
        
        return result
    }
    
    func getNumberOfCells() -> NSInteger
    {
        var cellCount = 0
        
        if(self.type == ReferenceType.book)
        {
            cellCount = 6
        }
        else if(self.type == ReferenceType.journal)
        {
            cellCount = 9
        }
        else if(self.type == ReferenceType.bookChapter)
        {
            cellCount = 10
        }
        else if(self.type == ReferenceType.webPage)
        {
            cellCount = 4;
        }
        
        return cellCount
    }
    
    func getTextInputForCell(_ position: Int) -> UITextAutocapitalizationType
    {
        if(position == 0 || position == 1)
        {
            return .none
        }
        else if(position == 2)
        {
            return .sentences
        }
        else if(self.type == .journal && (position == 3 || position == 4))
        {
            return .sentences
        }
        else if(self.type == .bookChapter && (position == 3 || position == 5 || position == 6))
        {
            return .sentences
        }
        else if(self.type == .webPage || position == 3)
        {
            return .none
        }
        else
        {
            return .words
        }
    }
    
    func getLabelsForCells() -> [String]
    {
        var labels = [String]()
        
        if(self.type == ReferenceType.book)
        {
            labels = self.getBookLabels()
        }
        else if(self.type == ReferenceType.journal)
        {
            labels = self.getJournalLabels()
        }
        else if(self.type == ReferenceType.bookChapter)
        {
            labels = self.getBookChapterLabels()
        }
        else if(self.type == ReferenceType.webPage)
        {
            labels = self.getWebLabels()
        }
        
        return labels
    }
    
    fileprivate func getBookLabels() -> [String]
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
    
    fileprivate func getJournalLabels() -> [String]
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
    
    fileprivate func getBookChapterLabels() -> [String]
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
    
    fileprivate func getWebLabels() -> [String]
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
        
        if(self.type == ReferenceType.book)
        {
            hints = self.getBookHints()
        }
        else if(self.type == ReferenceType.journal)
        {
            hints = self.getJournalHints()
        }
        else if(self.type == ReferenceType.bookChapter)
        {
            hints = self.getBookChapterHints()
        }
        else if(self.type == ReferenceType.webPage)
        {
            hints = self.getWebHints()
        }
        
        return hints
    }
    
    fileprivate func getBookHints() -> [String]
    {
        var hints = [String]()
        
        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter title")
        hints.append("(optional) enter subtitle")
        hints.append("enter location")
        hints.append("enter publisher")
        
        return hints
    }

    fileprivate func getJournalHints() -> [String]
    {
        var hints = [String]()
        
        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter title")
        hints.append("(optional) enter subtitle")
        hints.append("enter journal title")
        hints.append("enter volume number")
        hints.append("enter issue number")
        hints.append("enter page number")
        hints.append("enter doi/url")
        
        return hints
    }
    
    fileprivate func getBookChapterHints() -> [String]
    {
        var hints = [String]()

        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter chapter title")
        hints.append("(optional) enter chapter subtitle")
        hints.append("enter editors")
        hints.append("enter book title")
        hints.append("(optional) enter book subtitle")
        hints.append("enter pages of chapter")
        hints.append("enter location")
        hints.append("enter publisher")
        
        return hints
    }
    
    fileprivate func getWebHints() -> [String]
    {
        var hints = [String]()
        
        hints.append("enter author")
        hints.append("enter year")
        hints.append("enter chapter title")
        hints.append("enter url")
        
        return hints
    }
    
    func getValueForPosition(_ position: NSInteger) -> String
    {
        var value = ""
        
        if(type == ReferenceType.book)
        {
            value = getBookValueForPosition(position)
        }
        else if(type == ReferenceType.journal)
        {
            value = getJournalValueForPosition(position)
        }
        else if(type == ReferenceType.bookChapter)
        {
            value = getBookChapterValueForPosition(position)
        }
        else if(type == ReferenceType.webPage)
        {
            value = getWebValueForPosition(position)
        }
        
        return value
    }
    
    fileprivate func getBookValueForPosition(_ position: NSInteger) -> String
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
    
    fileprivate func getJournalValueForPosition(_ position: NSInteger) -> String
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
    
    fileprivate func getBookChapterValueForPosition(_ position: NSInteger) -> String
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
    
    func getWebValueForPosition(_ position: NSInteger) -> String
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
    
    func saveValueForPosition(_ position: NSInteger, value: String)
    {
        if(type == ReferenceType.book)
        {
            saveBookValueForPosition(position, value: value)
        }
        else if(type == ReferenceType.journal)
        {
            saveJournalValueForPosition(position, value: value)
        }
        else if(type == ReferenceType.bookChapter)
        {
            saveBookChapterValueForPosition(position, value: value)
        }
        else if(type == ReferenceType.webPage)
        {
            saveWebReferenceValueForPosition(position, value: value)
        }
    }
    
    fileprivate func saveBookValueForPosition(_ position: NSInteger, value: String)
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
    
    fileprivate func saveJournalValueForPosition(_ position: NSInteger, value: String)
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
    
    fileprivate func saveBookChapterValueForPosition(_ position: NSInteger, value: String)
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
    
    fileprivate func saveWebReferenceValueForPosition(_ position: NSInteger, value: String)
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
