//
//  SignUpViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/12/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
        
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        // When the Sign Up button is tapped
        let firstname: String = firstNameTextField.text ?? ""
        let lastname: String = lastNameTextField.text ?? ""
        let username: String = emailTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        print(firstname)
        print(lastname)
        print(username)
        print(password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Handling the text fields user input through delegate callbacks
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
