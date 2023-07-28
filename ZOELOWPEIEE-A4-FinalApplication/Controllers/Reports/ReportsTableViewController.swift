//
//  ReportsTableViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 31/05/2023.
//

import UIKit

class ReportsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Constants
    let CELL_REPORTS = "reportsCell"
    
    // MARK: - Variables
    var selectedFilename: String?
    var imagePathList = [String]()
    var filteredImagePathLists:[String] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Reports"
        navigationItem.searchController = searchController
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
        
    }
    
    ///This method ensures that the imagePathList property is updated with the latest filenames from the document directory and updates the search results accordingly whenever the view is about to appear on the screen.
    override func viewWillAppear(_ animated: Bool) {
        if let filenames = loadFileName() {
            imagePathList = filenames
        }
        
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    
    /// Loads the filenames of the files stored in the document directory.
    /// - Returns: An array of filenames as `[String]` or `nil` if an error occurs.
    func loadFileName() -> [String]? {
        var filenames:[String] = []
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                
            for fileURL in fileURLs {
                if let filename = fileURL.lastPathComponent as? String {
                        filenames.append(filename)
                    }
                }
            } catch {
                print("Error loading filenames from file manager: \(error)")
                // Handle the error as needed
            }
        return filenames
    }
    
    /// Updates the search results based on the search text entered in the search bar.
    /// - Parameter searchController: The `UISearchController` object responsible for handling the search.
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased()
        else {
            return
        }
        
        if searchText.count > 0 {
            // Filter the imagePathList based on the search text
            filteredImagePathLists = imagePathList.filter({ (filename: String) -> Bool in
                return (filename.lowercased().contains(searchText) )
            })
        } else{
            // If the search text is empty, reload the filteredImagePathLists with all filenames
            if let filenames = loadFileName() {
                filteredImagePathLists = filenames
            }
        }
        
        // Reload the table view to reflect the updated search results
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    /// Returns the number of sections in the table view.
    /// - Parameter tableView: The table view instance.
    /// - Returns: The number of sections in the table view.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// Returns the number of rows in the `filteredImagePathLists` array.
    /// - Parameters:
    ///   - tableView: The table view instance.
    ///   - section: The section index.
    /// - Returns: The number of rows in the specified section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredImagePathLists.count
    }

    /// This method dequeues a cell with the identifier `CELL_REPORTS` and configures its content using the corresponding image data from the `filteredImagePathLists` array.
    /// - Parameters:
    ///   - tableView: The table view instance.
    ///   - indexPath: The index path of the row.
    /// - Returns: The configured cell for the corresponding row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REPORTS, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = filteredImagePathLists[indexPath.row]
        cell.contentConfiguration = content

        return cell
    }
    
    
    /// Determines whether the specified row can be edited.
    /// - Parameters:
    ///   - tableView: The table view instance.
    ///   - indexPath: The index path of the row.
    /// - Returns: A Boolean value indicating whether the row can be edited.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    /// Override to support editing the table view.
    /// - Parameters:
    ///   - tableView: The table view instance.
    ///   - editingStyle: The editing style for the specified row.
    ///   - indexPath: The index path of the row.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            
            let filename = filteredImagePathLists[indexPath.row]
            let imageURL = documentsDirectory.appendingPathComponent(filename)
            print(filename)
            
            // Delete the image file
            do {
                try FileManager.default.removeItem(at: imageURL)
            } catch {
                print("Error deleting image file: \(error)")
                // Handle the error as needed
            }
            
            // Delete the row from the data source
            filteredImagePathLists.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    /// This method retrieves the corresponding filename from the `filteredImagePathLists` array based on the selected index path and performs a segue
    /// - Parameters:
    ///   - tableView: The table view instance.
    ///   - indexPath: The index path of the selected row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filename = filteredImagePathLists[indexPath.row]
        selectedFilename = filename
        performSegue(withIdentifier: "showReportsSegue", sender: self)
    }
    
    
     // MARK: - Navigation
     
    /// Prepares for the segue to `ShowReportViewController`.
    /// This method retrieves the destination view controller and assigns the selectedFilename value to its fileName property.
    /// - Parameters:
    ///   - segue: The segue instance.
    ///   - sender: The object that initiated the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReportsSegue" {
            if let destinationVC = segue.destination as? ShowReportViewController {
                destinationVC.fileName = selectedFilename
            }
        }
    }
    
}
