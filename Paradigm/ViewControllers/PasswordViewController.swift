//
//  PasswordViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 3/1/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBAction func updateTapped(_ sender: UIButton) {
        // When the Update button is tapped
        let currPass: String = currPassTextField.text ?? ""
        let newPass: String = newPassTextField.text ?? ""
        let confirmPass: String = confirmPassTextField.text ?? ""
        
        print(currPass)
        print(newPass)
        print(confirmPass)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Handling the text fields user input through delegate callbacks
        currPassTextField.delegate = self
        newPassTextField.delegate = self
        confirmPassTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
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
