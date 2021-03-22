//
//  JournalViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/22/21.
//  Copyright © 2021 team5. All rights reserved.
//

// TODO: Check if journal entry is already written today

import UIKit

class JournalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var journalTextField: UITextField!
    
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
            
//            let userID = Int(Utils.global_userID)!
            print(Utils.global_userID)
            let userID = 33
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        journalTextField.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MMM d yyyy")
        
        timeLabel!.text = ""
        timeLabel!.text! += dateFormatter.string(from: Date())
        
        dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
        timeLabel!.text! += " at " + dateFormatter.string(from: Date())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
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
