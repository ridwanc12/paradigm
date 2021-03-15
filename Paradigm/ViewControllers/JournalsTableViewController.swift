//
//  JournalsTableViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 3/15/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

struct Journal {
    var id : Int
    var date : Date
    var title : String
    var subtitle : String
    var text : String
}

private func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    return dateFormat.date(from: str)!
}

class JournalsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Temp Static Data for Table view testing
    
    let journals = [
        Journal(id: 1, date: parseDate("2021-03-15"), title: "Proin suscipit maximus", subtitle: "aliquam, vehicula, eget", text: "Nam molestie nunc in ipsum vehicula accumsan quis."),
        Journal(id: 2, date: parseDate("2021-03-12"), title: "In ac ante sapien", subtitle: "egestas, ultricies, dapibus", text: "Nam molestie nunc in ipsum vehicula accumsan quis sit amet quam. Sed vel feugiat eros."),
        Journal(id: 3, date: parseDate("2021-02-05"), title: "Lorem Ipsum", subtitle: "lorem, ipsum, dolor", text: "sit amet, consectetur adipiscing elit. Pellentesque id ornare tortor, quis dictum enim. Morbi convallis tincidunt quam eget bibendum. Suspendisse malesuada maximus ante, at molestie massa fringilla id."),
        Journal(id: 4, date: parseDate("2021-02-10"), title: "Aenean condimentum", subtitle:"massea, luctus, diam", text: "Ut eget massa erat. Morbi mauris diam, vulputate at luctus non, finibus et diam. Morbi et felis a lacus pharetra blandit."),
    ]
    
    // Grouping the Sections and ordering them by month and year
    struct MonthSection {
        var month: Date
        var journals: [Journal]
    }
    
    // Computing first day of the month
    private func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let date = section.month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Journal Cell", for: indexPath)
        
        let section = self.sections[indexPath.section]
        let journal = section.journals[indexPath.row]
        
        cell.textLabel?.text = journal.title
        cell.detailTextLabel?.text = journal.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    var sections = [MonthSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let groups = Dictionary(grouping: self.journals) { (journal) in
            return firstDayOfMonth(date: journal.date)
        }
        self.sections = groups.map { (key, values) in
            return MonthSection(month: key, journals: values)
        }
        
        // Sorting the sections
        self.sections.sort { (lhs, rhs) in lhs.month < rhs.month }
        
        
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
