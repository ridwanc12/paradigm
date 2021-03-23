//
//  EntryViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/22/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit
import Charts

class EntryViewController: UIViewController {
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
        // When the add button is pressed 
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        greetingLabel.text = "Hello, " + Utils.global_firstName
        
        let journals:[Double]! = [1, 2, 3, 4, 5, 6, 7]
//        let sentiments:[Double]! = [0.9, 0.3, -0.1, -0.6, 0.4, -0.7, 0.85]
        
        let sentiments = sevenDaySentiments()
        
        chartInitializer(journals: journals, sentiments: sentiments)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        greetingLabel.text = "Hello, " + Utils.global_firstName
    }
    
    func sevenDaySentiments() -> [Double] {
//        let fullentries = getJournalsRecent(userID: 33, num: 7)
        let fullentries = getJournals(userID: 33)
        
        var sents:[Double] = []
        for entry in fullentries {
            let score = Double(entry.sentScore)!
            sents.append(score)
        }
        
        print(sents)
        return sents
    }
    
    func chartInitializer(journals:[Double], sentiments:[Double]) {
        chart.noDataText = "No journal data available for chart."
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<journals.count {
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
        
        chart.backgroundColor = UIColor.white
        chart.layer.borderWidth = 3
        
        chart.data = data //add chart data to the chart and update
        chart.animate(yAxisDuration: 2, easingOption: ChartEasingOption.easeInOutSine)
//        chart.chartDescription?.text = "Mood over time" // Set the description for the graph
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
