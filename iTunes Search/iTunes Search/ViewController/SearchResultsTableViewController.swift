//
//  SearchResultsTableViewController.swift
//  iTunes Search
//
//  Created by Jonathan T. Miles on 8/7/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        searchBarOutlet.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBarOutlet.text else { return }
        var resultType: ResultType!
        
        switch segmentedOutlet.selectedSegmentIndex {
        case 0:
            resultType = .software
        case 1:
            resultType = .musicTrack
        case 2:
            resultType = .movie
        default:
            break
        }
        
        searchResultsController.performSearch(searchTerm: searchTerm, resultType: resultType) { (error) in
            if error != nil {
                NSLog("Error performing search function: \(String(describing: error)).")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsController.searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let result = searchResultsController.searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.creator
        return cell
    }

    // MARK: - Outlets and Properties
    
    let searchResultsController = SearchResultController()
    
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
}
