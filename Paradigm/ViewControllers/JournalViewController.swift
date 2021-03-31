//
//  JournalViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/22/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBOutlet weak var journalTextField: UITextView!
    
//    var updatedJournal = Journal(id: 0, date: Date(), title: "", tags: "", sentiment: 0, text: "")
    var updatedJournal = Journal(id: 0, created: Date(), lastedited: Date(), hidden: 0, sentiment: "", sentScore: 0, rating: 0, entry: "", topics: "")
    
    var isUpdate:Bool = false;
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // When the add entry button is tapped
        let entry: String = journalTextField.text!
        
        if (entry.isEmpty) {
            let alert = UIAlertController(title: "Empty Journal", message: "Your journal is empty!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction( title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else {
            let analysis = getJournalAnalysis(journal: entry)!
            print(analysis)
            
            let topics = phrasesToString(phrases: analysis.phrases.KeyPhrases)
            
            // TODO: Currently there are issues with the global user id
            
            let userID = Int(Utils.global_userID)!
            let journal = entry
            let sentiment = analysis.sentiment.Sentiment
            let rating = 0
            let positive = analysis.sentiment.SentimentScore.Positive
            let negative = analysis.sentiment.SentimentScore.Negative
            let mixed = analysis.sentiment.SentimentScore.Mixed
            let neutral = analysis.sentiment.SentimentScore.Neutral
            let sentScore = positive - negative
            
            insertJournal(userID: userID, journal: journal, sentiment: sentiment, rating: rating, topics: topics, positive: positive, negative: negative, mixed: mixed, neutral: neutral, sentScore: sentScore)
            
            journalTextField.text! = ""
            
            let alert = UIAlertController(title: "Journal Entered", message: "Your journal has been successfully entered!", preferredStyle: .alert)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeView = storyboard.instantiateViewController(identifier: "HomeViewController")
            
            alert.addAction(UIAlertAction( title: "OK", style: .default, handler: {(alert: UIAlertAction!) in (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeView)}))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        // If the user is updating the journal
        if isUpdate {
            updatedJournal.entry = entry
            print(updatedJournal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        journalTextField.delegate = self
        journalTextField.isScrollEnabled = false
        journalTextField.text = "Today's Journal"
        journalTextField.textColor = .lightGray
        
        errorLabel.isHidden = true
        titleLabel.isHidden = true
        
        titleLabel.sizeToFit()
        timeLabel.sizeToFit()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MMM d yyyy")
        
        timeLabel!.text = ""
        timeLabel!.text! += dateFormatter.string(from: Date())
        
        dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
        timeLabel!.text! += " at " + dateFormatter.string(from: Date())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (isUpdate) {
            journalTextField.text = updatedJournal.entry
            journalTextField.textColor = .black
            titleLabel.isHidden = false
            titleLabel.text = "Edit Journal"
            addButton.setTitle("Update", for: .normal)
            
            // Create the Navigation Bar
            self.setNavigationBar()
          
          }
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelTapped))
        
        navItem.rightBarButtonItem = cancelItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc
    func cancelTapped(Sender: UIBarButtonItem) -> Void {
        print("Cancel Tapped")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if (numberOfChars >= 280) {
            errorLabel.isHidden = false
        }
        else {
            errorLabel.isHidden = true
        }
        
        return numberOfChars <= 280
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Today's Journal" && textView.textColor == .lightGray) {
            textView.text = ""
            textView.textColor = .black
        }
        //Optional
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
                textView.text = "Today's Journal"
                textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
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
