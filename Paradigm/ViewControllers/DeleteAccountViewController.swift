//
//  DeleteAccountViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 3/24/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        let confirmPass: String = confirmPassTextField.text ?? ""
        
        if (confirmPass == "") {
            let alert = UIAlertController(title: "Empty Field", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            
            let deleteAccountAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This action cannot be undone.", preferredStyle: .alert)
            
            deleteAccountAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
                //try to delete account from database
                let ret = self.databaseRequestDeleteAccount(email: Utils.global_email, pass: confirmPass)
                print("RET VALUE: " + ret)
                
                if (ret == "User deleted.") {
                    //user successfully deleted, return to welcome screen
                    // Setting the User Defaults to false
                    UserDefaults.standard.set(false, forKey: "status")
                    
                    // After user has successfully logged out
              
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginView = storyboard.instantiateViewController(identifier: "LoginViewController")

                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginView)
                } else if (ret == "Incorrect password. Please try again.") {
                    let incorrectPassAlert = UIAlertController(title: "Incorrect Password", message: "Please enter your correct password to delete your account.", preferredStyle: .alert)
                    incorrectPassAlert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                    self.present(incorrectPassAlert, animated: true)
                    self.confirmPassTextField.text = ""
                } else {
                    let incorrectPassAlert = UIAlertController(title: "Oops!", message: "Something went wrong on our end. Please try again.", preferredStyle: .alert)
                    incorrectPassAlert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                    self.present(incorrectPassAlert, animated: true)
                }
                
                
            }))
            
            deleteAccountAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("User cancels deleting account.")
                //do nothing
              }))
            self.present(deleteAccountAlert, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func databaseRequestDeleteAccount(email: String, pass: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/deleteUser.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(email)&password=\(pass)"
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
