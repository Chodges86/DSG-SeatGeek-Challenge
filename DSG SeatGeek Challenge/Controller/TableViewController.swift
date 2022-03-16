//
//  TableViewController.swift
//  DSG SeatGeek Challenge
//
//  Created by Caleb Hodges on 3/14/22.
//

import UIKit

var favoriteEvents = [Int]()

class TableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var model = DataModel()
    var eventArray: [Event] = []
    var selectedEvent: Event?
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        searchBar.delegate = self
        
        // Register custom tableview cell
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "event")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // Setup appearance of search bar
        searchBar.searchTextField.leftView?.tintColor = .systemGray // mag glass color
        searchBar.backgroundImage = UIImage() // Get rid of border around search bar
        
        // Load favorites from UserDefaults
        favoriteEvents = defaults.array(forKey: "Favorites") as? [Int] ?? []
        
        // Kick off the API call
        model.getData()
        
    }
    
// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! TableViewCell
        
        // eventArray contains events from API calls.  Received from the protocol DataRecieved.  Updated with each change in the search bar.
        cell.title.text = eventArray[indexPath.row].short_title
        cell.time.text = model.formatTime(eventArray[indexPath.row].datetime_utc)
        
        let city = eventArray[indexPath.row].venue.city
        let state = eventArray[indexPath.row].venue.state
        let location = "\(city), \(state)"
        cell.location.text = location
        
        let pic =  model.urlToImage(eventArray[indexPath.row].performers[0].image)
        
        if let safePic = pic {
            cell.thumbnail.image = safePic
        } else {
            cell.thumbnail.image = UIImage(systemName: "questionmark")
        }
        
        // Display heart if event is a favorite
        if favoriteEvents.contains(eventArray[indexPath.row].id) {
            cell.heart.alpha = 1
        } else {
            cell.heart.alpha = 0
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set the selected event to be passed to the Details VC
        selectedEvent = eventArray[indexPath.row]
        performSegue(withIdentifier: "Details Segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass selected event to the Details VC
        let destVC = segue.destination as! DetailsViewController
        destVC.event = selectedEvent
        
    }
    
}

//MARK: - DataModel Protocol Delegate Methods

extension TableViewController: DataReceived {
    func didReceiveData(data: SeatGeekData) {
        
        eventArray = [] // Reset array at each update
        
        for event in data.events {
            eventArray.append(event)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didReceiveError(error: Error?) {
        
        // Unwrap error message and setup for localized description
        var errorMessage = String()
        if let safeError = error {
            errorMessage = safeError.localizedDescription
        }
        // Display alert for any errors
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "Error: \(errorMessage)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - SearchBar Delegate Methods

extension TableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Recall API with change to search bar
        model.getData(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Final call when typing is finished.  Not really necessary
        model.getData(searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear search bar and reset to unfiltered events
        model.getData()
        searchBar.text = ""
    }
}
