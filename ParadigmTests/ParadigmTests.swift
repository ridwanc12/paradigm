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
    
    func testSuccessfulPositiveRequest1() {
        let journal = "After classes, I took my girlfriend out to dinner at a new Thai restaurant. We had a great time walking around the park afterwards and enjoying nature."
        let analysis = getJournalAnalysis(journal: journal)!
        let sentiment = analysis.sentiment.Sentiment
        print(sentiment)
        XCTAssertEqual(sentiment, "POSITIVE")
    }

}
