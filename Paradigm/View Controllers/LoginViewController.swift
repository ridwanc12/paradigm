//
//  LoginViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/10/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func restoreButtonTapped (_ sender: UIButton) {
        // When the restore password button is tapped
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // When the Log In button is tapped
        let username: String = emailTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        print(username)
        print(password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        // Handling the text fields user input through delegate callbacks
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
}
