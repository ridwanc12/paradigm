//
//  JournalsTableViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 3/15/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class JournalsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Temp Arrays for Table view testing
    let journals = ["Journal 1", "Journal 2", "Journal 3", "Journal 4"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = journals[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
