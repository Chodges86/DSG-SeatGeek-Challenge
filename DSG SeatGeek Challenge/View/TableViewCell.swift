//
//  TableViewCell.swift
//  DSG SeatGeek Challenge
//
//  Created by Caleb Hodges on 3/14/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    
  
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the appearance of the cells subviews
        eventView.layer.cornerRadius = eventView.frame.size.height / 10
        eventView.layer.shadowOffset = CGSize(width: 0, height: 5)
        eventView.layer.shadowRadius = 10
        eventView.layer.shadowOpacity = 0.2
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
