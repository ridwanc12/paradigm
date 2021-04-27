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
    
    //biometric login
    @IBOutlet weak var biometricButton: UIButton!
    let bioTouch = BiometricIDAuth()
    @IBAction func bioLoginTapped(_ sender: Any) {
        let email: String = emailTextField.text ?? ""
        if (email == "") { //check if email field empty
            let alert = UIAlertController(title: "Empty Email Field", message: "Please enter your email in order to use Biometric login.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            bioTouch.authenticateUser() { [weak self] in
                //self?.performSegue(withIdentifier: "dismissLogin", sender: self)
                print("successful authentication")
                print(email)
                //need php script for obtaining all info from just email
                //will login with that after getting all info
            }
        }
    }
    
    @IBAction func restoreButtonTapped (_ sender: UIButton) {
        // When the restore password button is tapped
        
        let email: String = emailTextField.text ?? ""
        
        if (email == "") {
            let alert = UIAlertController(title: "Empty Email Field", message: "Please enter your email in order to restore your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            let ret = databaseRequestRestorePassword(email: email)
            print("RET VALUE: " + ret)
            
            if (ret.contains("Password resetted")) {
                let alert = UIAlertController(title: "Success", message: "Please check your email for instructions on how to access your account.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Oops!", message: "Something went wrong on our end. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // When the Log In button is tapped
        let email: String = emailTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        //show alert if textfields are empty
        if (email == "" || password == "") {
            
            let alert = UIAlertController(title: "Empty Field", message: "Please enter all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            print(email)
            print(password)
            let ret = databaseRequestLogIn(email: email, password: password)
            print("RET VALUE: " + ret)
            
            if (ret.contains("Login successful")) {
                
                //Storing user data into Utils
                Utils.global_email = email
                UserDefaults.standard.set(email, forKey: "email")
                struct UserData: Decodable {
                    let userID: String
                    let firstName: String
                    let lastName: String
                }
                let successMessage = "Login successful"
                let json_index = ret.index(ret.startIndex, offsetBy: successMessage.count)
                let parsed_json = String(ret[json_index...])
                let data = parsed_json.data(using: .utf8)!
                do {
                    let userdata: UserData = try JSONDecoder().decode(UserData.self, from: data)
                    Utils.global_userID = userdata.userID
                    UserDefaults.standard.set(userdata.userID, forKey: "userID")
                    Utils.global_firstName = userdata.firstName
                    UserDefaults.standard.set(userdata.firstName, forKey: "firstName")
                    Utils.global_lastName = userdata.lastName
                    UserDefaults.standard.set(userdata.lastName, forKey: "lastName")
                } catch {
                    print(error)
                }
                
                
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
            } else if (ret == "Please verify your account first.") {
                let alert = UIAlertController(title: "Verify Account", message: "Please verify your account using the email that was sent to you.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if (ret == "Oops! Something went wrong. Please try again later." || ret == "ERROR") {
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
        // Do any additional setup after loading the view
        
        // First launch is done
        // Setting the User Defaults to true
        UserDefaults.standard.set(true, forKey: "firstLaunch")
        
        // Handling the text fields user input through delegate callbacks
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //check if biometric login available
        //print(!bioTouch.canEvaluatePolicy())
        biometricButton?.isHidden = !bioTouch.canEvaluatePolicy()
        //set corresponding image for touchID or faceID
        // TODO: Isha set button images if you want that for the UI
//        switch bioTouch.biometricType() {
//        case .faceID:
//            biometricButton.setImage(UIImage(named: ""),  for: .normal)
//        default:
//            biometricButton.setImage(UIImage(named: ""),  for: .normal)
//        }

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
    
    func databaseRequestRestorePassword(email: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/resetPass.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(email)"
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
    
    // Logging in through biometrics
    func databaseRequestLogInBio(email: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/bio_login.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(email)"
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
