//
//  EntryViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/22/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit
import Charts

class EntryViewController: UITableViewController {
    
    
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var chartBackground: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    var tenTopics:[String] = []
    var tenSentiments:[Double] = []
    
    let colorTop = UIColor(red: 116.0 / 255.0, green: 255.0 / 255.0, blue: 8.0 / 255.0, alpha: 0.325).cgColor
    let colorBottom = UIColor(red: 255.0 / 255.0, green: 84.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.325).cgColor
    
    @IBAction func addButton(_ sender: UIButton) {
        // When the add button is pressed 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        greetingLabel.text = "Hello, " + Utils.global_firstName

        
        // Setup gradient background for chart
        setGradientBackground()
        
        let journals:[Double]! = [1, 2, 3, 4, 5, 6, 7]
//        let sentiments:[Double]! = [0.9, 0.3, -0.1, -0.6, 0.4, -0.7, 0.85]
        
        let entries = getJournalsRecent(userID: Int(Utils.global_userID)!, num: 7)
//        let entries = getJournals(userID: Int(Utils.global_userID)!)
        
        let sentiments = journalSentiments(entries: entries)
        
        chartInitializer(journals: journals, sentiments: sentiments)
        
        (tenTopics, tenSentiments) = journalTopics(entries: entries)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        greetingLabel.text = "Hello, " + Utils.global_firstName
    }
    
    func journalSentiments(entries: [RetJournal]) -> [Double] {
        var sents:[Double] = []
        for entry in entries {
            let score = Double(entry.sentScore)!
            sents.append(score)
        }
        
        return sents
    }
    
    func chartInitializer(journals:[Double], sentiments:[Double]) {
        if (sentiments.isEmpty) {
            chart.noDataText = "No journal data available for chart."
            return
        }
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<sentiments.count {
            let value = ChartDataEntry(x: journals[i], y: sentiments[i]) // set data entry X and Y
            lineChartEntry.append(value) // add to data set
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Sentiment") //convert lineChartEntry to LineChartDataSet
        line1.colors = [NSUIColor.blue] //Set color to blue
        line1.lineWidth = 3
        line1.circleRadius = 4
        line1.circleHoleRadius = 0
        line1.circleColors = [NSUIColor.black]
        line1.mode = .cubicBezier
        
        let data = LineChartData() // Object for chart
        data.addDataSet(line1) //Add line to dataSet
        data.setDrawValues(true)
        
        // Axis and gridline configuration
        chart.leftAxis.axisMinimum = -1
        chart.leftAxis.axisMaximum = 1
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        chart.xAxis.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = false
        
        // Background color and border setup
        chart.backgroundColor = UIColor.white
        chart.layer.borderWidth = 3
        
        chart.data = data //add chart data to the chart and update
        chart.animate(yAxisDuration: 2, easingOption: ChartEasingOption.easeInOutSine)
//        chart.chartDescription?.text = "Mood over time" // Set the description for the graph
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = chartBackground.bounds
                
        chartBackground.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func journalTopics(entries: [RetJournal]) -> ([String], [Double]) {
        var posTopicFrequency:[String: Int] = [:]
        var posTopicSentiment:[String: Double] = [:]
        
        var negTopicFrequency:[String: Int] = [:]
        var negTopicSentiment:[String: Double] = [:]
        
        // Calculate total sentiment and frequency
        for entry in entries {
            let entryTopics = entry.topics.split(separator: ",")
            for entryTopic in entryTopics {
                posTopicFrequency[String(entryTopic), default: 0] += 1
                posTopicSentiment[String(entryTopic), default: 0.0] += Double(entry.sentScore)!
            }
        }
        
        // Divide into positive and negative topics
        for (topic, sentiment) in posTopicSentiment {
            if (sentiment <= 0) {
                negTopicFrequency[topic] = posTopicFrequency[topic]
                posTopicFrequency.removeValue(forKey: topic)
                negTopicSentiment[topic] = posTopicSentiment[topic]
                posTopicSentiment.removeValue(forKey: topic)
            }
        }
        
        var tenTopics:[String] = []
        var tenSentiments:[Double] = []
        
        // Sort and get top 5 topics for each with avg sentiment
        let sortedPos = posTopicSentiment.sorted {
            return $0.value > $1.value
        }
        
        for item in sortedPos.prefix(5) {
            let trimmedTopic = item.key.trimmingCharacters(in: .whitespacesAndNewlines)
            tenTopics.append(trimmedTopic)
            tenSentiments.append(item.value / Double(posTopicFrequency[item.key]!))
        }
        
        let sortedNeg = negTopicSentiment.sorted {
            return $0.value < $1.value
        }
        
        for item in sortedNeg.prefix(5) {
            let trimmedTopic = item.key.trimmingCharacters(in: .whitespacesAndNewlines)
            tenTopics.append(trimmedTopic)
            tenSentiments.append(item.value / Double(negTopicFrequency[item.key]!))
        }
        
        return (tenTopics, tenSentiments)
        
    }
    
    // Table View Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tenTopics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chart Cell", for: indexPath)
        
        cell.textLabel?.text = tenTopics[indexPath.row]
        
        let roundedSentiment = (tenSentiments[indexPath.row] * 100).rounded() / 100
        cell.detailTextLabel?.text = String(roundedSentiment)
        
        if (roundedSentiment >= 0) {
            cell.contentView.backgroundColor = UIColor(cgColor: colorTop)
        }
        else {
            cell.contentView.backgroundColor = UIColor(cgColor: colorBottom)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weekly Topics                             Avg Sentiment"
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
