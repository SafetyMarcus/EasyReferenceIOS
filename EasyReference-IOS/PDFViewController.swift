//
//  PDFViewController.swift
//  EasyReference-IOS
//
//  Created by Marcus on 9/05/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class PDFViewController: UIViewController, MFMailComposeViewControllerDelegate
{
    var referenceList = ReferenceList()
    
    var style = "<head><style>h1 {text-align: center; font-size: 30; font-weight: bold;} p {margin-left: 22px; margin-right: 5px; text-indent: -17px;}</style></head>"
    
    @IBOutlet var webview: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var html = "\(style) <h1>References</h1>"
        for index in 0...referenceList.references.count - 1
        {
            html = "\(html)<p>\(referenceList.references[index].getHtmlReferenceString())</p></br>"
        }
        webview.loadHTMLString(html, baseURL: nil)
    }
    
    @IBAction func Send(sender: AnyObject)
    {
        let pdfName = "\(referenceList.name).pdf"
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        let documentsDirectory: String = paths[0] as! String
        
        let pdfPath = "\(documentsDirectory)/\(pdfName)";
        createPDFfromUIView(pdfPath)

        var mail = MFMailComposeViewController()
        mail.setSubject("\(referenceList.name)")
        mail.setMessageBody("Created in EasyReference", isHTML: false)
        mail.mailComposeDelegate = self
        
        let fileData = NSData(contentsOfFile: pdfPath)
        mail.addAttachmentData(fileData, mimeType: "application/pdf", fileName: "\(referenceList.name).pdf")
        
        self.presentViewController(mail, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createPDFfromUIView(fileName: String)
    {
        // Creates a mutable data object for updating with binary data, like a byte array
        let heightStr = webview.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight;")
        let height = heightStr?.toInt()
        let webHeight = Int(webview.bounds.height)
        
        let pages = height!/webHeight
    
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, webview.bounds, nil);
    
        let frame = webview.frame
        for i in 0...pages
        {
            // Check to screenHeight if page draws more than the height of the UIWebView
            if ((i+1) * webHeight  > height)
            {
//                let f = webview.frame
//                
//                let size = Float(f.size.height)
//                let sizeToRemove = ((i+1) * webHeight) - height!
//                
//                f.size.height = CGFloat(size - sizeToRemove)
//                webview.frame = f
            }
    
            UIGraphicsBeginPDFPage();
            let currentContext = UIGraphicsGetCurrentContext()
    
            let y = Float(webHeight) * Float(i)
            let point = CGPointMake(0, CGFloat(y))
            
            webview.subviews.last?.setContentOffset(point, animated: false)
            webview.layer.renderInContext(currentContext)
        }
    
        UIGraphicsEndPDFContext()
        pdfData.writeToFile(fileName, atomically: true)
        webview.frame = frame
    }
}