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
    var created : Date
    var lastedited : Date
    var hidden : Int
    var sentiment : String
    var sentScore : Double
    var rating : Int
    var entry : String
    var topics : String
}

func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    return dateFormat.date(from: str)!
}

// Computing first day of the month
func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components)!
}

// Grouping the Sections and ordering them by month and year
struct MonthSection {
    var month: Date
    var journals: [Journal]
    
    static func group(journals : [Journal]) -> [MonthSection] {
        let groups = Dictionary(grouping: journals) { journal in
            firstDayOfMonth(date: journal.created)
        }
        return groups.map(MonthSection.init(month:journals:))
    }
}

class JournalsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    
    // Temp Static Data for Table view testing
    
    var journals: [Journal] = [
        Journal(id: 1, created: parseDate("2021-03-15"), lastedited: parseDate("2021-03-15"), hidden: 0, sentiment: "POSITIVE", sentScore: 0.98, rating: 8, entry: "After classes, I took my girlfriend out to dinner at a new Thai restaurant. We had a great time walking around the park afterwards and enjoying nature.", topics: "girlfriend, Thai, park, great time"),
        Journal(id: 2, created: parseDate("2021-03-12"), lastedited: parseDate("2021-03-12"), hidden: 0, sentiment: "NEUTRAl", sentScore: 0.7, rating: 8, entry: "I am so excited for valentine's day tomorrow so I can eat a lot of dessert. I want a puppy.", topics: "valentine, day, a lot, dessert, a puppy"),
        Journal(id: 3, created: parseDate("2021-02-10"), lastedited: parseDate("2021-02-10"), hidden: 0, sentiment: "NEGATIVE", sentScore: 0.1, rating: 8, entry: "Wake up at 9 am to attend the job I hate 11 minutes late for my shift. End me.", topics: "9 am, job, hate"),
        Journal(id: 4, created: parseDate("2021-02-05"), lastedited: parseDate("2021-02-05"), hidden: 0, sentiment: "MIXED", sentScore: 0.1, rating: 8, entry: "Today, I got some chores done after work, and did some meal-prep for the next few days after going to the gym.", topics: "some chores, work, some meal-prep, the gym")
    ]
    
    // Implementing the Search Bar
    var searchController = UISearchController(searchResultsController: nil)
    var filteredJournals:[Journal] = []
    
    // Checking if the text typed in the search bar is empty
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Checking if the search bar is active
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return "Results"
        }
        let section = self.sections[section]
        let date = section.month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredJournals.count
        }
        let sect = self.sections[section]
        return sect.journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Journal Cell", for: indexPath)
        
        let section = self.sections[indexPath.section]
        
        let journal: Journal
        
        if isFiltering {
            journal = filteredJournals[indexPath.row]
        }
        else {
            journal = section.journals[indexPath.row]
        }
        
        //cell.textLabel?.text = journal.title
        cell.detailTextLabel?.text = journal.topics
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var sections = [MonthSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sections = MonthSection.group(journals: self.journals)
        
        // Sorting the sections
        self.sections.sort { (lhs, rhs) in lhs.month < rhs.month }
        
        // Implementing Search Bar
        // Inform the class of any text changes in the search bar
        searchController.searchResultsUpdater = self
        
        // Show the information in the current view
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Journals"
        
        // Adding the search bar to the Navigation Item
        navigationItem.searchController = searchController
        
        // Exit Search Bar if user navigates to different page
        definesPresentationContext = true
        
        
    }

    func filterContentForSearchText(_ searchText: String) {
      filteredJournals = journals.filter { (journal: Journal) -> Bool in
        return journal.entry.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as? DetailViewController
        let section = sections[tableView.indexPathForSelectedRow!.section].journals
        
        let journal: Journal
        if isFiltering {
            journal = filteredJournals[tableView.indexPathForSelectedRow!.row]
        }
        else {
            journal = section[tableView.indexPathForSelectedRow!.row]
        }
        
        // Send the current selected journal data to the Detail View Controller
        vc?.journal = journal
    }
    

}


