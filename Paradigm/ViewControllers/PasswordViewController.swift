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
        
        if (confirmPass != newPass) {
            // check if the passwords are same
            let alert = UIAlertController(title: "Passwords Do Not Match", message: "Please make sure that both passwords entered match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            newPassTextField.text = ""
            confirmPassTextField.text = ""
        } else if (!passwordStrength(password: newPass)){
            //password strength checker
            let alert = UIAlertController(title: "Password Not Strong", message: "Password length must be at least 6 characters and include a number, lowercase letter and uppercase letter.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            newPassTextField.text = ""
        } else {
            //password update criteria met
            
            let ret = databaseRequestChangePassword(oldPass: currPass, newPass: newPass, email: Utils.global_email)
            print("RET VALUE: " + ret)
            
            if (ret == "Password changed.") {
                //successfully changed password
                let alert = UIAlertController(title: "Success", message: "Your account's password has been updated.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if (ret == "Incorrect password. Please try again.") {
                //incorrect current password entered
                let alert = UIAlertController(title: "Incorrect Password", message: "The current password you entered is incorrect, please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                currPassTextField.text = ""
            } else {
                //handle all other errors
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
        currPassTextField.delegate = self
        newPassTextField.delegate = self
        confirmPassTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
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
    
    func databaseRequestChangePassword(oldPass: String, newPass: String, email: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/changePass.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(email)&oldPass=\(oldPass)&newPass=\(newPass)"
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
