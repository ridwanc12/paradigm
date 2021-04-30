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

    
    @IBOutlet weak var textView: UITextView!
    
    var password:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Loading the html page for the Terms and Conditions
        textView.text = """
Welcome to Paradigm.

These Terms and Conditions constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and Paradigm, concerning your access to and use of our mobile application ("Paradigm"). You agree that by accessing the Application, you have read, understood, and agree to be bound by all of these Terms and Conditions Use. IF YOU DO NOT AGREE WITH ALL OF THESE TERMS AND CONDITIONS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE APPLICATION AND YOU MUST DISCONTINUE USE IMMEDIATELY.

Supplemental terms and conditions or documents that may be posted on the Application from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms and Conditions at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of these Terms and Conditions and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review these Terms and Conditions to stay informed of updates. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Terms and Conditions by your continued use of the Application after the date such revised Terms are posted.

The information provided on the Application is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Application from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.

These Terms and Conditions were generated by Termly’s Terms and Conditions Generator.

Paradigm is intended for users who are at least 18 years old. Persons under the age of 13 are not permitted to register for the Application.
"""
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        // When the accept button is tapped
        // Change the root view to the Main Page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeView = storyboard.instantiateViewController(identifier: "HomeViewController")

        // Getting the SceneDelegate object from the view controller
        // Changing the root view controller

        // Using User Defaults to keep a user logged in
        UserDefaults.standard.set(true, forKey: "status")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeView)
    }
    
    @IBAction func declineTapped(_ sender: Any) {
        // Dismiss the popover Terms and Conditions page
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
        let ret = databaseRequestDeleteAccount(email: Utils.global_email, pass: password)
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
