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
    @IBOutlet weak var confirmPasswordTextField: UITextField!
        
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        // When the Sign Up button is tapped
        let firstname: String = firstNameTextField.text ?? ""
        let lastname: String = lastNameTextField.text ?? ""
        let email: String = emailTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        let confirmPassword: String = password //confirmPasswordTextField.text ?? ""
        
        print(firstname)
        print(lastname)
        print(email)
        print(password)
        print(confirmPassword)
        
        if (firstname == "" ||
            lastname == "" ||
            email == "" ||
            password == "" ||
            confirmPassword == "") {
            let alert = UIAlertController(title: "Empty Field", message: "Please enter all the fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if (!isValidEmail(email: email)) {
            let alert = UIAlertController(title: "Invalid Email", message: "Please make sure to provide a valid email address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if (confirmPassword != password) {
            // check if the passwords are same
            let alert = UIAlertController(title: "Passwords Do Not Match", message: "Please make sure that both passwords entered match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            passwordTextField.text = ""
            //confirmPasswordTextField.text = ""
        } else if (!passwordStrength(password: password)){
            //password strength checker
            let alert = UIAlertController(title: "Password Not Strong", message: "Password length must be at least 6 characters and include a number, lowercase letter and uppercase letter.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            passwordTextField.text = ""
            //confirmPasswordTextField.text = ""
        }
        
        
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
    
    // function to verify strong password entered
    func passwordStrength(password: String) ->Bool {
        if ((password.range(of: "[a-z]", options: .regularExpression) != nil) &&
            (password.range(of: "[A-Z]", options: .regularExpression) != nil) &&
            (password.range(of: "[0-9]", options: .regularExpression) != nil) &&
            (password.count >= 6)) {
            debugPrint("password strong")
            return true
        } else {
            return false
        }
    }
    
    // function to verify email field contains a valid email
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func databaseRequest(first: String, last: String, email: String, password: String) -> Int {
        return 0;
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
