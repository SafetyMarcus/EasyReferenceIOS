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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PDFViewController: UIViewController, MFMailComposeViewControllerDelegate
{
    var referenceList = ReferenceList()
    
    var style = "<head><style>h1 {text-align: center; font-size: 30; font-weight: bold;} p {margin-left: 22px; margin-right: 5px; text-indent: -17px; word-wrap: break-word;}</style></head><body>"
    
    @IBOutlet var webview: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var html = "\(style) <h1>References</h1>"
        
        var references = referenceList.getReferences()
        for index in 0...references.count - 1
        {
            html = "\(html)<p>\(references[index].getHtmlReferenceString())</p>"
        }
        
        html = "\(html)</body>"
        webview.loadHTMLString(html, baseURL: nil)
    }
    
    @IBAction func Send(_ sender: AnyObject)
    {
        let pdfName = "\(referenceList.name).pdf"
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        let documentsDirectory: String = paths[0] 
        
        let pdfPath = "\(documentsDirectory)/\(pdfName)";
        createPDFfromUIView(pdfPath)

        let mail = MFMailComposeViewController()
        mail.setSubject("\(referenceList.name)")
        mail.setMessageBody("Created in EasyReference", isHTML: false)
        mail.mailComposeDelegate = self
        
        let fileData = try? Data(contentsOf: URL(fileURLWithPath: pdfPath))
        mail.addAttachmentData(fileData!, mimeType: "application/pdf", fileName: "\(referenceList.name).pdf")
        
        self.present(mail, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "UnwindToMain", sender: self.webview)
    }
    
    func createPDFfromUIView(_ fileName: String)
    {
        // Creates a mutable data object for updating with binary data, like a byte array
        let heightStr = webview.stringByEvaluatingJavaScript(from: "document.body.scrollHeight;")
        let height = heightStr?.characters.count
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
            let point = CGPoint(x: 0, y: CGFloat(y))
            
            (webview.subviews.last as! UIScrollView).setContentOffset(point, animated: false)
            webview.layer.render(in: currentContext!)
        }
    
        UIGraphicsEndPDFContext()
        pdfData.write(toFile: fileName, atomically: true)
        webview.frame = frame
    }
}
