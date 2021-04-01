//
//  DetailViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 3/15/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    var journID = 0
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleTextField: UITextView!

    @IBOutlet weak var sentimentTextField: UITextField!
    @IBOutlet weak var sentScoreTextField: UITextField!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteTapped(_ sender: Any) {
        // When the delete button is tapped
        //TODO: Need jourID
        
        let deleteEntryAlert = UIAlertController(title: "Delete Entry", message: "Are you sure you want to delete this entry? This action cannot be undone.", preferredStyle: .alert)
        
        deleteEntryAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            //try to delete account from database
            let ret = self.databaseRequestDeleteEntry(jourID: String(self.journID))
            print("RET VALUE: " + ret)
            
            if (ret == "Entry deleted.") {
                // Entry successfully deleted, return to journals screen
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                
                //uncomment if want to return to welcome screen after delete
                /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeView = storyboard.instantiateViewController(identifier: "HomeViewController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeView)*/
                
            } else {
                let incorrectPassAlert = UIAlertController(title: "Oops!", message: "Something went wrong on our end. Please try again.", preferredStyle: .alert)
                incorrectPassAlert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(incorrectPassAlert, animated: true)
            }
            
        }))
        
        deleteEntryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("User cancels deleting account.")
            //do nothing
          }))
        self.present(deleteEntryAlert, animated: true, completion: nil)
        
    }
    
    
    var journal = Journal(id: 0, created: Date(), lastedited: Date(), hidden: 0, sentiment: "", sentScore: 0.00, rating: 0, entry: "", topics: "")

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
        
        
        if isEditing {
            print("yes editing")
            deleteButton.isHidden = false;
            
            // Making text fields editable
            subtitleTextField.isEditable = true
            sentScoreTextField.isEnabled = true
            
        }
        else {
            print("not editing")
            deleteButton.isHidden = true;
            
            // Making text fields not editable
            subtitleTextField.isEditable = false
            sentScoreTextField.isEnabled = false
            
            // Edited components
            // TODO: Add the updated field data to the database
            print(subtitleTextField.text ?? "Null")
            print(sentScoreTextField.text ?? "Null")
            print(sentimentTextField.text ?? "Null")
            
            let updatedSentScore = Double(sentScoreTextField.text ?? "") ?? 0.0
            print(updatedSentScore)
            let updatedTopics = subtitleTextField.text ?? ""
            print(updatedTopics)
            var allowEdit = true
            
            if (updatedSentScore < -1.0 || updatedSentScore > 1.0) {
                //custom sent score out of range
                allowEdit = false
                let alert = UIAlertController(title: "Invalid Score", message: "Please enter a decimal value between -1.0 and 1.0.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            if (updatedTopics == "") {
                //empty custom topics
                allowEdit = false
                let alert = UIAlertController(title: "Empty Topics", message: "Please enter comma separated topics you'd like to highlight in this entry.", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            if (allowEdit) {
                // call databaserequest
                // pos, neg, mix, neutral not really being updated
                print("calling edit entry request")
                var sentiment = "POSITIVE"
                if (updatedSentScore <= 0.0) {
                    sentiment = "NEGATIVE"
                }
                let ret = databaseRequestEditEntry(jourID: String(journID), entry: journal.entry, sentiment: sentiment, sentScore: String(updatedSentScore), hidden: String(journal.hidden), rating: String(journal.rating), topics: updatedTopics, positive: "0.0", negative: "0.0", mixed: "0.0", neutral: "0.0")
                if (ret == "Entry edited") {
                    let alert = UIAlertController(title: "Success", message: "Entry successfully updated.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Oops!", message: "Something went wrong on our end, please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction( title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                
            }
            
            // TODO: Update the label of the Sentiment based on the sentScore
            // what are the parameters?
            
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.isEditing {
            if indexPath.section == 0 && indexPath.row == 0 {
                
                performSegue(withIdentifier: "updateJournalSegue", sender: self)
            }
            
        }
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Hiding the delete button when the view loads
        deleteButton.layer.cornerRadius = 4
        deleteButton.isHidden = true;
        
        // Delegations for the text field
        subtitleTextField.delegate = self
        subtitleTextField.isScrollEnabled = false
        subtitleTextField.isEditable = false
        
        sentimentTextField.delegate = self
        sentimentTextField.isEnabled = false
        
        sentScoreTextField.delegate = self
        sentScoreTextField.isEnabled = false
        
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 3 && indexPath.row == 0 {
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Setting up the label data
        titleLabel.text = journal.entry
        subtitleTextField.text = journal.topics
        sentimentTextField.text = String(journal.sentiment)
        let roundedSentiment = (journal.sentScore * 100).rounded() / 100
        sentScoreTextField.text = String(roundedSentiment)
        
        titleLabel.sizeToFit()
        subtitleTextField.sizeToFit()
        sentimentTextField.sizeToFit()
        sentScoreTextField.sizeToFit()
        
        timeLabeler(label: &timeLabel!.text!, date: journal.lastedited)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func databaseRequestDeleteEntry(jourID: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/deleteEntry.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "jourID=\(jourID)"
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
    
    func databaseRequestEditEntry(jourID: String, entry: String, sentiment: String, sentScore: String, hidden: String, rating: String, topics: String, positive: String, negative: String, mixed: String, neutral: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var ret = "";
        
        let link = "https://boilerbite.000webhostapp.com/paradigm/editEntry.php"
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = "jourID=\(jourID)&entry=\(entry)&sentiment=\(sentiment)&sentScore=\(sentScore)&hidden=\(hidden)&rating=\(rating)&topics=\(topics)&positive=\(positive)&negative=\(negative)&mixed=\(mixed)&neutral=\(neutral)"
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


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as? JournalViewController
        
        // Send the current selected journal data to the Detail View Controller
        vc?.updatedJournal = journal
        vc?.isUpdate = true
    }

}
