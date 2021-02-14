//
//  LambdaRequest.swift
//  Paradigm
//
//  Created by Ridwan Chowdhury on 2/13/21.
//  Copyright © 2021 team5. All rights reserved.
//

import Foundation

func getJournalAnalysis(journal: String) -> Analysis? {
    let semaphore = DispatchSemaphore (value: 0)

    let parameters = journal
    let postData = parameters.data(using: .utf8)

    var request = URLRequest(url: URL(string: "https://0z0hapmzrd.execute-api.us-east-2.amazonaws.com/default/paradigm")!,timeoutInterval: Double.infinity)
    request.addValue("hdjpB8yRUI640F5IvYdLQ4bs7qsfzfEH55Tz7KGA", forHTTPHeaderField: "x-api-key")
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"
    request.httpBody = postData
    
    var analysis: Analysis?

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
            analysis = try JSONDecoder().decode(Analysis.self, from: data!)
            semaphore.signal()
        } catch {
            print("There was an error in the lambda request")
            print(error)
            semaphore.signal()
        }
    }

    task.resume()
    // 15 second maximum timeout
    _ = semaphore.wait(timeout: .now() + 15)
    
    return(analysis)
}
