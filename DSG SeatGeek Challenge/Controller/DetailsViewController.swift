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
    @IBOutlet weak var heartButton: UIButton!
    
    var event: Event? // Selected event from tableview selection
    
    let model = DataModel()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event != nil {
            
            eventTitle.text = event!.short_title
            time.text = model.formatTime(event!.datetime_utc)
            let city = event!.venue.city
            let state = event!.venue.state
            location.text = "\(city), \(state)"
            image.image = model.urlToImage(event!.performers[0].image)
            
            // Determine if event is a favorite
            if favoriteEvents.contains(event!.id) {
                // Is a favorite
                heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                // Not a favorite
                heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("button Tapped")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Functionality for favorite events
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        
        // Event is not a favorite and being added to list
        if heartButton.imageView?.image == UIImage(systemName: "heart") {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
            favoriteEvents.append(event!.id)
            defaults.set(favoriteEvents, forKey: "Favorites")
            
            // Event is a favorite and being removed from list
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            
            favoriteEvents.removeAll(where: {$0 == event!.id})
            defaults.set(favoriteEvents, forKey: "Favorites")
        }
    }
}
