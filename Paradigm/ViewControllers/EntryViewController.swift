//
//  EntryViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/22/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
        // When the add button is pressed 
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        greetingLabel.text = "Hello, " + Utils.global_firstName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        greetingLabel.text = "Hello, " + Utils.global_firstName
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
