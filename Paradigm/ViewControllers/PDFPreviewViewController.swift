//
//  PDFPreviewViewController.swift
//  Paradigm
//
//  Created by Domenic Conversa on 4/16/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    
    public var documentData: Data?
    
    var tenTopics:[String] = []
    var tenSentiments:[Double] = []
    var chart:UIImage = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pdfCreator = PDFCreator(firstName: Utils.global_firstName, tenTopics: tenTopics, tenSentiments: tenSentiments, chart: chart)
        self.documentData = pdfCreator.createFlyer()
        
        // Add PDFView to view controller.
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        // Fit content in PDFView.
        pdfView.autoScales = true
        
        // Load Sample.pdf file from app bundle.
        //let fileURL = Bundle.main.url(forResource: "Sample", withExtension: "pdf")
        //pdfView.document = PDFDocument(url: fileURL!)
        
        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
