//
//  DetailsViewController.swift
//  DSG SeatGeek Challenge
//
//  Created by Caleb Hodges on 3/15/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var event: Event? // Selected event from tableview selection
    
    let model = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event != nil {
            
            eventTitle.text = event!.short_title
            time.text = model.formatTime(event!.datetime_utc)
            let city = event!.venue.city
            let state = event!.venue.state
            location.text = "\(city), \(state)"
            image.image = model.urlToImage(event!.performers[0].image)
            
        }
    
}
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
