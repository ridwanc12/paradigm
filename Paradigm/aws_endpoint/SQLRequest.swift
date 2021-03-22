//
//  SQLRequest.swift
//  Paradigm
//
//  Created by Ridwan Chowdhury on 3/3/21.
//  Copyright © 2021 team5. All rights reserved.
//

import Foundation

func insertJournal(userID: Int, journal: String, sentiment: String, rating: Int, topics: String, positive: Double, negative: Double, mixed: Double, neutral: Double, sentScore: Double) {
    
    // Convert from types to String
    let userID2 = String(userID)
    let rating2 = String(rating)
    let positive2 = String(positive)
    let negative2 = String(negative)
    let mixed2 = String(mixed)
    let neutral2 = String(neutral)
    let sentScore2 = String(sentScore)

    let semaphore = DispatchSemaphore (value: 0)
    var ret = "";
    
    let link = "https://boilerbite.000webhostapp.com/paradigm/insertEntry.php"
    let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
    request.httpMethod = "POST"
    
    let postString = "userID=\(userID2)&rating=\(rating2)&positive=\(positive2)&negative=\(negative2)&mixed=\(mixed2)&neutral=\(neutral2)&sentScore=\(sentScore2)&entry=\(journal)&sentiment=\(sentiment)&topics=\(topics)"
    request.httpBody = postString.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
        
        if error != nil {
            print("ERROR")
            print(String(describing: error!))
            ret = "ERROR"
            semaphore.signal()
            return
        }
        
        print("PRINTING DATA")
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        ret = String(describing: responseString!)
        print(ret)
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    
}

func getJournals(userID: Int) -> [RetJournal] {
    let semaphore = DispatchSemaphore (value: 0)

    let parameters = [
        [
            "key": "userID",
            "value": userID,
            "type": "text"
        ]] as [[String : Any]]

    let boundary = "Boundary-\(UUID().uuidString)"
    var body = ""
    let _: Error? = nil
    for param in parameters {
        if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
                body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
                let paramValue = param["value"] as! Int
                body += "\r\n\r\n\(paramValue)\r\n"
            } else {
                do {
                    let paramSrc = param["src"] as! String
                    let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                        + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                } catch let error1 as NSError {
                    print(error1)
                }
            }
        }
    }
    body += "--\(boundary)--\r\n";
    let postData = body.data(using: .utf8)

    var request = URLRequest(url: URL(string: "https://boilerbite.000webhostapp.com/paradigm/getEntry.php")!,timeoutInterval: Double.infinity)
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"
    request.httpBody = postData
    
    var retJournals: [RetJournal] = []

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
        }
        do {
//            print(String(data: data, encoding: .utf8)!)
            retJournals = try JSONDecoder().decode([RetJournal].self, from: data)
        }
        catch {
            print("There was an error in the JSON conversion")
            print(error)
        }
        semaphore.signal()
    }

    task.resume()
    semaphore.wait()
    
    return(retJournals)
}

func getJournalsRecent(userID: Int, num: Int) -> [RetJournal] {
    var journals = getJournals(userID: userID)
    journals = journals.suffix(num)
    
    return journals
}

func getQuote() -> String{

    let semaphore = DispatchSemaphore (value: 0)
    var ret = "";
    
    let link = "https://boilerbite.000webhostapp.com/paradigm/getQuote.php"
    let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
    request.httpMethod = "POST"
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
        
        if error != nil {
            print("ERROR")
            print(String(describing: error!))
            ret = "ERROR"
            semaphore.signal()
            return
        }
        
//        print("PRINTING DATA")
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        ret = String(describing: responseString!)
        print(ret)
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    return ret
}
