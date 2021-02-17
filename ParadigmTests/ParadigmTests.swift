//
//  ParadigmTests.swift
//  ParadigmTests
//
//  Created by Ridwan Chowdhury on 2/13/21.
//  Copyright © 2021 team5. All rights reserved.
//

import XCTest
@testable import Paradigm

class ParadigmTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequest() {
        let journal = "Wake up at 9 am to attend the job i hate 11 minutes late for my shift. End me."
        let analysis = getJournalAnalysis(journal: journal)!
        print(analysis)
    }
    
    func testRequestPositive1() {
        let journal = "After classes, I took my girlfriend out to dinner at a new Thai restaurant. We had a great time walking around the park afterwards and enjoying nature."
        let analysis = getJournalAnalysis(journal: journal)!
        let sentiment = analysis.sentiment.Sentiment
        print(sentiment)
        XCTAssertEqual(sentiment, "POSITIVE")
    }
    
    func testRequestNegative1() {
        let journal = "I had a fight with one of my co-workers today. We had an argument about their lack of contribution to the team and its negative impact on the project."
        let analysis = getJournalAnalysis(journal: journal)!
        let sentiment = analysis.sentiment.Sentiment
        print(sentiment)
        XCTAssertEqual(sentiment, "NEGATIVE")
    }
    
    func testRequestPolarity1() {
        let journal = "I had a fight with one of my co-workers today. We had an argument about their lack of contribution to the team and its negative impact on the project."
        let analysis = getJournalAnalysis(journal: journal)!
        let polarity = analysis.sentiment.SentimentScore.Neutral
        print(polarity)
        XCTAssertTrue(polarity < 0.5)
    }
    
    func testRequestPolarity2() {
        let journal = "Today, I got some chores done after work, and did some meal-prep for the next few days after going to the gym."
        let analysis = getJournalAnalysis(journal: journal)!
        let polarity = analysis.sentiment.SentimentScore.Neutral
        print(polarity)
        XCTAssertTrue(polarity > 0.5)
    }
    
    func testRequestTopic1() {
        let journal = "I am so excited for valentine's day tomorrow so I can eat a lot of dessert. I want a puppy."
        let analysis = getJournalAnalysis(journal: journal)!
        let topics = analysis.phrases.KeyPhrases
        
        let expected = ["valentine", "day", "a lot", "dessert", "a puppy"]
        var contains = false
        
        for topic in topics {
            if (expected.contains(topic.Text)) {
                contains = true
            }
        }
        
        XCTAssert(contains)
    }
    
    func testRequestTopic2() {
        let journal = "Today, I got some chores done after work, and did some meal-prep for the next few days after going to the gym."
        let analysis = getJournalAnalysis(journal: journal)!
        let topics = analysis.phrases.KeyPhrases
        
        let expected = ["some chores", "work", "some meal-prep", "the gym"]
        var contains = false
        
        for topic in topics {
            if (expected.contains(topic.Text)) {
                contains = true
            }
        }
        
        XCTAssert(contains)
    }

}
