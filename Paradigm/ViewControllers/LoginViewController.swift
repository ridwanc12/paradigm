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
        let email: String = emailTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        //show alert if textfields are empty
        if (email == "" ||
            password == "") {
            
            let alert = UIAlertController(title: "Empty Field", message: "Please enter all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            print(email)
            print(password)
            let ret = databaseRequestLogIn(email: email, password: password)
            print("RET VALUE: " + ret)
            
            if (ret == "Login successful") {
                // Using User Defaults to keep a user logged in
                UserDefaults.standard.set(true, forKey: "status")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeView = storyboard.instantiateViewController(identifier: "HomeViewController")
                
                // Getting the SceneDelegate object from the view controller
                // Changing the root view controller
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeView)
            } else if (ret == "Incorrect password. Please try again.") {
                let alert = UIAlertController(title: "Incorrect Password.", message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if (ret == "Email not registered.") {
                let alert = UIAlertController(title: "Account Not Found", message: "An account has not been created with the email you entered.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if (ret == "Oops! Something went wrong. Please try again later." || ret == "ERROR") {
                let alert = UIAlertController(title: "Oops!", message: "Something went wrong on our end. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
        
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
    
    func databaseRequestLogIn(email: String, password: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/login.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(email)&password=\(password)"
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
        }
        task.resume()
        semaphore.wait()
        return ret
    }
}
