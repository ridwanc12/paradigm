//
//  DeleteAccountViewController.swift
//  Paradigm
//
//  Created by Ridwan Chowdhury on 4/26/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class ResourceViewController: UIViewController {
    
    @IBOutlet weak var okayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func okayButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeView = storyboard.instantiateViewController(identifier: "HomeViewController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeView)
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
