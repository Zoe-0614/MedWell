//
//  ViewNewsTableViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Soo yew Lim on 01/06/2023.
//

import UIKit

/// The view controller will display all the latest news related to Health fetched from the API called and provide users the option to search for news.
class ViewNewsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    //MARK: - Properties
    let CELL_NEWS = "newsCell"
    var newNews = [NewsData]()
    var filteredNewNews:[NewsData] = []
    var selectedNews: NewsData?
    var indicator = UIActivityIndicatorView()
    
    //MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    // MARK: - Table view data source
    
    /// Returns the number of sections in the table view.
    /// - Parameter tableView: The table view instance.
    /// - Returns: The number of sections in the table view.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Returns the number of rows in the `filteredNewNews` array.
    /// - Parameters:
    ///   - tableView: The table view instance.
    ///   - section: The section index.
    /// - Returns: The number of rows in the specified section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNewNews.count
    }

    
    /// This method dequeues a cell with the identifier `CELL_NEWS` and configures its content using the corresponding image data from the `filteredNewNews` array.
    /// - Parameters:
    ///   - tableView: The table view instance.
    ///   - indexPath: The index path of the row.
    /// - Returns: The configured cell for the corresponding row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NEWS, for: indexPath)

        let news = filteredNewNews[indexPath.row]
        cell.textLabel?.text = news.title
        cell.detailTextLabel?.text = news.author
        
        return cell
    }
    
    
    /// Prepares for the segue to `NewsDetailsViewController`.
    /// This method retrieves the destination view controller and assigns the selected news data to its news property.
    /// - Parameters:
    ///   - segue: The segue instance.
    ///   - sender: The object that initiated the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showNewsSegue" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destination = segue.destination as! NewsDetailsViewController
                destination.news = filteredNewNews[indexPath.row]
            }
        }
    }
    
    
    
    /// Makes an asynchronous request to fetch news data.
    func requestNews() async{

        // Setting up the URL components for the Currents API request
        // Specifies the scheme, host, path, and query parameters.
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "api.currentsapi.services"
        searchURLComponents.path = "/v1/latest-news"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: "Rv25whPKOaWA7_m1Y5YkxDROkRBYwMrl8-jrbsJkCFNXg9eF"),
            URLQueryItem(name: "category", value: "health"),
            URLQueryItem(name: "language", value: "en")
        ]
        
        // Checking the validity of the request URL
        guard let requestURL = searchURLComponents.url else{
            print("Invalid URL")
            return
        }
        
        // Creating a URL request
        let urlRequest = URLRequest(url: requestURL)
        
        // Making an asynchronous network request
        do{
            // Fetches the data from the provided URL request
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            indicator.stopAnimating()
            
            // Parse the data
            let decoder = JSONDecoder()
            // The received data is parsed using a JSONDecoder to decode it into VolumeNews objects.
            let newsData = try decoder.decode(VolumeNews.self, from: data)
            
            //The decoded news objects are stored in the newNews array
            for new in newsData.news{
                newNews.append(new)
            }
            filteredNewNews = newNews
            tableView.reloadData()
            
        } catch let error{
            print (error)
        }
    }
    
    
    /// Updates the search results based on the search text entered.
    /// - Parameter searchController: The search controller responsible for handling the search interaction.
    func updateSearchResults(for searchController: UISearchController) {
        // Starting the loading indicator
        indicator.startAnimating()
        
        // Making an asynchronous network request to fetch the latest news data
        Task {
            await requestNews()
        }
        
        // If the search text is empty or nil, the function returns and no further processing is done.
        guard let searchText = searchController.searchBar.text?.lowercased()
        else {
            return
        }
        
        // Filter the news data based on the search text.
        if searchText.count > 0{
            filteredNewNews = newNews.filter({ (news: NewsData) -> Bool in
                if let newsTitle = news.title{
                    return (newsTitle.lowercased().contains(searchText) )
                }
                return false
            })
        } else{
            filteredNewNews = newNews
        }
        
        tableView.reloadData()
    }
    
}
