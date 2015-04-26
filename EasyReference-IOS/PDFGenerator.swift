//
//  PDFGenerator.swift
//  EasyReference-IOS
//
//  Created by Marcus on 26/04/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import CoreData
import CoreText
import UIKit

class PDFGenerator
{
    var id = ""
    var context : NSManagedObjectContext
    
    init(listId: String, context: NSManagedObjectContext)
    {
        id = listId
        self.context = context
    }
    
    func generate() -> String
    {
        var referenceList = getReferenceList()
        let pdfName = "\(referenceList.name).pdf"
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        let documentsDirectory: String = paths[0] as! String
        
        let pdfPath = "\(documentsDirectory)/\(pdfName)";
        
        var currentText: CFAttributedStringRef = CFAttributedStringCreate(nil, referenceList.getReferenceText(), nil)

        var framesetter = CTFramesetterCreateWithAttributedString(currentText)
        if((framesetter) != nil)
        {
            // Create the PDF context using the default page size of 612 x 792.
            let pageSize = CGRect(x: 0, y: 0, width: 612, height: 792)
            
            UIGraphicsBeginPDFContextToFile("\(documentsDirectory)/\(pdfName)", pageSize, nil);
                
            var currentRange = CFRangeMake(0, 0);
            var done = false;
                
            do
            {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
                
                // Render the current page and update the current range to
                // point to the beginning of the next page.
                currentRange = renderPage(currentRange, frameSetter: framesetter)
                    
                // If we're at the end of the text, exit the loop.
                if(currentRange.location == CFAttributedStringGetLength(currentText))
                {
                    done = true;
                }
                
            } while (!done);
                
            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
        } else {
                NSLog("Could not create the framesetter needed to lay out the atrributed string.");
        }
        
        return pdfPath
    }
    
    func getReferenceList() -> ReferenceList
    {
        var error : NSError?
        let fetchRequest = NSFetchRequest(entityName: "ReferenceList")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        let fetchResults: [NSManagedObject] = context.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]
        
        return ReferenceList(reference: fetchResults[0], context: self.context)
    }
    
    func renderPage(currentRange: CFRange, frameSetter: CTFramesetterRef) -> CFRange
    {
        // Get the graphics context.
        let currentContext = UIGraphicsGetCurrentContext();
        
        // Put the text matrix into a known state. This ensures
        // that no old scaling factors are left in place.
        CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
        
        // Create a path object to enclose the text. Use 72 point
        // margins all around the text.
        let frameRect = CGRectMake(72, 72, 468, 648);
        let framePath = CGPathCreateMutable();
        CGPathAddRect(framePath, nil, frameRect);
        
        // Get the frame that will do the rendering.
        // The currentRange variable specifies only the starting point. The framesetter
        // lays out as much text as will fit into the frame.
        let frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, nil);
        
        // Core Text draws from the bottom-left corner up, so flip
        // the current transform prior to drawing.
        CGContextTranslateCTM(currentContext, 0, 792);
        CGContextScaleCTM(currentContext, 1.0, -1.0);
        
        // Draw the frame.
        CTFrameDraw(frameRef, currentContext);
        
        // Update the current range based on what was drawn.
        var newRange = CTFrameGetVisibleStringRange(frameRef);
        newRange.location = currentRange.location + currentRange.length;
        newRange.length = 0;
        
        return newRange;
    }
 }