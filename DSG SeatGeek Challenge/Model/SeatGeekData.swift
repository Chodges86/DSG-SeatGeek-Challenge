//
//  Data.swift
//  DSG SeatGeek Challenge
//
//  Created by Caleb Hodges on 3/14/22.
//

import Foundation


struct SeatGeekData: Codable {
    
    var events: [Event]
    
}

struct Event: Codable {
    
    let datetime_utc: String
    let short_title: String
    var venue: Venue
    var performers: [Performers]
    
    
}

struct Venue: Codable {

    let state: String
    let city: String


}

struct Performers: Codable {

    var image: URL?

}
