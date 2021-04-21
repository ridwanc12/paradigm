//
//  TermsViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 4/20/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController, WKNavigationDelegate , WKUIDelegate {

    
    @IBOutlet weak var customView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Loading the html page for the Terms and Conditions
        let url = URL(string: "https://developer.apple.com/documentation/webkit/wkwebview")
            let request = URLRequest(url: url!)
            let webView = WKWebView(frame: self.customView.frame)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight] //It assigns Custom View height and width
            webView.navigationDelegate = self
            
            webView.load(request)
            self.customView.addSubview(webView)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        // When the accpet button is tapped
        // Change the root view to the Main Page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeView = storyboard.instantiateViewController(identifier: "HomeViewController")

        // Getting the SceneDelegate object from the view controller
        // Changing the root view controller

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeView)
    }
    
    @IBAction func declineTapped(_ sender: Any) {
        // Dismiss the popover Terms and Conditions page
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
