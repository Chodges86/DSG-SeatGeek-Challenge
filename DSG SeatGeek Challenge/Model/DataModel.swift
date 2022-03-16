//
//  DataManager.swift
//  DSG SeatGeek Challenge
//
//  Created by Caleb Hodges on 3/14/22.
//

import Foundation
import Metal
import UIKit

protocol DataReceived {
    func didReceiveData(data: SeatGeekData)
    func didReceiveError(error: Error?)
}


struct DataModel {
    
    let apiKey = "MjYxMTI2MTR8MTY0NzI5ODA5OC4zOTE3NDA2"
    var delegate: DataReceived?
    
//MARK: - Get Data from API
    
    func getData(_ text: String = "") {
        
        // Set up the URL
        let textToSearch = "&q=\(text)"
        let urlString = "https://api.seatgeek.com/2/events?client_id=\(apiKey)\(textToSearch)"
        let url = URL(string: urlString)
        
        // Prepare for call
        let session = URLSession(configuration: .default)
        if let url = url {
            
            let dataTask = session.dataTask(with: url) { data, response, error in
                
                //Handle error in call
                if error != nil {
                    print("error getting data: \(error!)")
                    delegate?.didReceiveError(error: error)
                }
                // Parse JSON
                if data != nil {
                    let decoder = JSONDecoder()
                    do {
                        let data = try decoder.decode(SeatGeekData.self, from: data!)
                        delegate?.didReceiveData(data: data)
                        
                    } catch {
                        //Handle error in parsing
                        print("Error Parsing JSON: \(error)")
                        delegate?.didReceiveError(error: error)
                    }
                }
            }
            dataTask.resume()
        }
        
    }
// MARK: - Format Time function
    
    func formatTime(_ date: String) -> String {
        
        // Format date string to usable UTC
        var dateString = String()
        var dayString = String()
        var newDate = date
        newDate = newDate.replacingOccurrences(of: "T", with: " ")
        newDate.append(" UTC")
        
        // Setup DateFormatter
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        dateFormatter2.timeZone = TimeZone(abbreviation: "UTC")
        
        // Get date and day from string and format
        // Day seperated out so it can be uppercased
        if let date = dateFormatter.date(from: newDate){
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
            dateString = dateFormatter.string(from: date)
            dateFormatter2.dateFormat = "E"
            dayString = dateFormatter2.string(from: date).uppercased()
        }
        
        let finalDateString = "\(dayString), \(dateString)"
        return finalDateString
    }

//MARK - Get image from API URL
    func urlToImage(_ url: URL?) -> UIImage? {
        
        guard url != nil else {return nil}
        
        let data = try? Data(contentsOf: url!)
        
        if let data = data {
            let imageFromURL = UIImage(data: data)
            return imageFromURL
        } else {
            return nil
        }
    }
}
