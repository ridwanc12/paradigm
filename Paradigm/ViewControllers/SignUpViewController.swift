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
        let confirmPassword: String = confirmPasswordTextField.text ?? "" //confirmPasswordTextField.text ?? ""
        
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
        } else {
            //all account creation criteria met
            
            //storing user data in Utils
            Utils.global_email = email
            UserDefaults.standard.set(email, forKey: "email")
            Utils.global_firstName = firstname
            UserDefaults.standard.set(firstname, forKey: "firstName")
            Utils.global_lastName = lastname
            UserDefaults.standard.set(lastname, forKey: "lastName")
            
            let ret = databaseRequestCreateAccount(first: firstname, last: lastname, email: email, password: password, confirmPassword: confirmPassword)
            print("RET VALUE: " + ret)
            if (ret.contains("account created")) {
                
                //Storing user ID in Utils
                let successMessage = "account createdMessage sent!"
                let id_index = ret.index(ret.startIndex, offsetBy: successMessage.count + 1)
                let parsed_id = ret[id_index...]
                Utils.global_userID = String(parsed_id)
                UserDefaults.standard.set(String(parsed_id), forKey: "userID")
                
                // Using User Defaults to keep a user logged in
                UserDefaults.standard.set(true, forKey: "status")
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let homeView = storyboard.instantiateViewController(identifier: "HomeViewController")
//                
//                // Getting the SceneDelegate object from the view controller
//                // Changing the root view controller
//
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeView)
                
            } else if (ret == "This email is already registered.") {
                let alert = UIAlertController(title: "Account already exists.", message: "An account has already been created with this email. Please use a different email.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if (ret == "ERROR" || ret == "Something went wrong.") {
                let alert = UIAlertController(title: "Oops!", message: "Something went wrong on our end. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Oops!", message: "Something went wrong on our end. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
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
        confirmPasswordTextField.delegate = self
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
            //debugPrint("password strong")
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
    
    func databaseRequestCreateAccount(first: String, last: String, email: String, password: String, confirmPassword: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/signup.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(email)&password=\(password)&confirm_password=\(confirmPassword)&firstName=\(first)&lastName=\(last)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("ERROR")
                print(String(describing: error!))
                ret = "ERROR"
                semaphore.signal()
                return
            }
            
            print("PRINTING DATA")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            ret = String(describing: responseString!)
            semaphore.signal()
            print(ret)
        }
        task.resume()
        semaphore.wait()
        return ret
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
