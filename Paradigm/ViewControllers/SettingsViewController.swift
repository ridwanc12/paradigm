//
//  SettingsViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/16/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
//    // Setting up the Table View
//    private let tableView: UITableView = {
//        let table = UITableView(frame: .zero, style: .grouped)
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return table
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.frame = view.bounds
        
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Hello World"
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
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
