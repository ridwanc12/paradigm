//
//  DetailViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 3/15/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleTextField: UITextView!

    @IBOutlet weak var sentimentTextField: UITextField!
    @IBOutlet weak var sentScoreTextField: UITextField!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteTapped(_ sender: Any) {
        // When the delete button is tapped
    }
    
    
    var journal = Journal(id: 0, created: Date(), lastedited: Date(), hidden: 0, sentiment: "", sentScore: 0.00, rating: 0, entry: "", topics: "")

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
        
        if isEditing {
            deleteButton.isHidden = false;
            
            // Making text fields editable
            subtitleTextField.isEditable = true
            sentScoreTextField.isEnabled = true
            
        }
        else {
            deleteButton.isHidden = true;
            
            // Making text fields not editable
            subtitleTextField.isEditable = false
            sentScoreTextField.isEnabled = false
            
            // Edited components
            // TODO: Add the updated field data to the database
            print(subtitleTextField.text ?? "Null")
            print(sentimentTextField.text ?? "Null")
            
            // TODO: Update the label of the Sentiment based on the sentScore
            
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
