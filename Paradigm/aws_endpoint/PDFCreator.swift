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
    func createFlyer() -> Data {
        // create dictionary for pdf metadata
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "raywenderlich.com"
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
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            let text = "I'm a PDF!"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }

        return data
    }
}
