//
//  PDFCreator.swift
//  Paradigm
//
//  Created by Domenic Conversa on 4/16/21.
//  Copyright © 2021 team5. All rights reserved.
//
//  Written with help from: https://www.raywenderlich.com/4023941-creating-a-pdf-in-swift-with-pdfkit

import Foundation
import PDFKit

class PDFCreator {
    
    var tenTopics:[String] = []
    var tenSentiments:[Double] = []
    var chart:UIImage = UIImage()
    var firstName = ""
    var title = ""
    var body = ""
    
    init(firstName: String, tenTopics: [String], tenSentiments: [Double], chart: UIImage) {
        self.tenTopics = tenTopics
        self.tenSentiments = tenSentiments
        self.firstName = firstName
        self.title = firstName + "'s Paradigm Report"
        self.chart = chart
        
        var body = "The following are your main topics with their corresponding sentiment scores:\n"
        for i in 0...(tenTopics.count - 1) {
            if (i == tenTopics.count - 1) {
                body = body + tenTopics[i] + " (" + String(tenSentiments[i]) + ")"
            } else {
                body = body + tenTopics[i] + " (" + String(tenSentiments[i]) + "), "
            }
        }
        self.body = body
        
    }

    
    func createFlyer() -> Data {
        // create dictionary for pdf metadata
        let pdfMetaData = [
            kCGPDFContextCreator: "Paradigm",
            kCGPDFContextAuthor: "Paradigm Team",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        // set to 8.5"x11" size
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        // create pdf renderer of size specified above
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        // create pdf
        let data = renderer.pdfData { (context) in
            // starts new page (call again for new page)
            context.beginPage()
            // set font size and write string
            let titleBottom = addTitle(pageRect: pageRect)
            let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
            addBodyText(pageRect: pageRect, textTop: imageBottom + 18.0)
        }

        return data
    }
    
    func addTitle(pageRect: CGRect) -> CGFloat {
        // set font and size for title
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        // create dictionary for title attributes
        let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: titleFont]
        // create string with title text
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
        )
        // obtain size that title will take up
        let titleStringSize = attributedTitle.size()
        // create centered rectangle to hold title
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 36,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        // actually draw title
        attributedTitle.draw(in: titleStringRect)
        // returns coordinates
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addBodyText(pageRect: CGRect, textTop: CGFloat) {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        // set paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        // create dictionary for attributes of body text
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(
            string: body,
            attributes: textAttributes
        )
        // create rectangle to hold body text and draw
        let textRect = CGRect(
            x: 10,
            y: textTop,
            width: pageRect.width - 20,
            height: pageRect.height - textTop - pageRect.height / 5.0
        )
        attributedText.draw(in: textRect)
    }
    
    func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        // image can be at most 40% of the page’s height and 80% of the page’s width
        let maxHeight = pageRect.height * 0.4
        let maxWidth = pageRect.width * 0.8
        
        // calculate ratios to resize image for best fit
        let aspectWidth = maxWidth / chart.size.width
        let aspectHeight = maxHeight / chart.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        // calculate scaled height and width
        let scaledWidth = chart.size.width * aspectRatio
        let scaledHeight = chart.size.height * aspectRatio
        
        // center image
        let imageX = (pageRect.width - scaledWidth) / 2.0
        let imageRect = CGRect(x: imageX, y: imageTop, width: scaledWidth, height: scaledHeight)
        
        // draw image
        chart.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
}
