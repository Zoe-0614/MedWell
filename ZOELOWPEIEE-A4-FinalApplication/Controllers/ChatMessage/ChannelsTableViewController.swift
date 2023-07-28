//
//  ChannelsTableViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 27/04/2023.
//

import UIKit

///The `ChannelsTableViewController` class is responsible for displaying a list of channels for chat messages and handling user interactions
class ChannelsTableViewController: UITableViewController, DatabaseListener {
    
    //MARK: Properties
    var listenerType = ListenerType.channels
    weak var databaseController: DatabaseProtocol?
    let SEGUE_CHANNEL = "channelSegue"
    let CELL_CHANNEL = "channelCell"
    var currentSender: Sender?
    var channels = [Channel]()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    ///This method is called to perform necessary setup tasks just before the view is about to be displayed on the screen.
    ///- Parameter animated: A boolean indicating whether the transition to the view will be animated.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        databaseController?.setupChannelsListener()
    }
    
    ///This method is called to perform necessary cleanup tasks just before the view is about to be removed from the screen.
    /// - Parameter animated: A boolean indicating whether the transition from the view will be animated.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        databaseController?.disposeChannelsListener()
        
    }
    
    //MARK: - Database listeners
    
    // Not implemented - not used
    func onAllTodosChange(change: DatabaseChange, todos: [ToDoListItem]) {
    }
    
    /// This method is called when there is a change in the channels data from the database.
    /// It updates the channels array and the current sender, and reloads the table view to reflect the changes.
    /// - Parameters:
    ///    - change:  A `DatabaseChange` enum value indicating the type of change that occurred.
    ///    - channels: An array of `Channel` objects representing the updated channels data.
    ///    - currentSender: A `Sender` object representing the current sender.
    func onAllChannelsChange(change: DatabaseChange, channels: [Channel], currentSender: Sender) {
        self.channels = channels
        self.currentSender = currentSender
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    /// Adds a new chat channel.
    /// - Parameter sender: The object that triggered the action.
    @IBAction func addChannel(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Chat", message: "Enter chat name below", preferredStyle: .alert)
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Create", style: .default) { _ in
            let channelName = alertController.textFields![0]
            var doesExist = false
            for channel in self.channels {
                if let name = channel.name{
                    if name.lowercased() == channelName.text!.lowercased() {
                        doesExist = true
                    }
                }
            }
            if !doesExist {
                if let name = channelName.text{
                    self.databaseController?.addChannel(channelName: name)
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        self.present(alertController, animated: false, completion: nil)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    /// This method is called by the table view to determine the number of sections to display.
    ///- Parameter tableView: The table view requesting the number of sections.
    /// - Returns: The number of sections in the table view.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// This method returns the count of the `channels` array, which represents the number of channels available.
    /// - Parameters:
    ///   - tableView: The table view requesting the number of rows.
    ///   - section: The section index for which to determine the number of rows.
    /// - Returns: The number of rows in the specified section of the table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    /// This method dequeues a cell with the identifier `CELL_CHANNEL` and configures its content using the corresponding channel data from the `channels` array.
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: The index path specifying the location of the cell in the table view.
    /// - Returns: A configured table view cell for the specified index path.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CHANNEL, for: indexPath)
        
        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        let channel = channels[indexPath.row]
        content.text = channel.name
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    ///This method retrieves the corresponding channel from the `channels` array based on the selected index path and performs a segue to the `ChatMessagesViewController` with the selected channel as the sender.
    /// - Parameters:
    ///   - tableView: The table view containing the selected row.
    ///   - indexPath: The index path of the selected row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        performSegue(withIdentifier: SEGUE_CHANNEL, sender: channel)
    }
    
    
    // MARK: - Navigation
    /// This method prepares the destination view controller and passes the necessary data.
    /// - Parameters:
    ///   - segue: The segue object containing information about the navigation.
    ///   - sender: The object that initiated the navigation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_CHANNEL {
            let channel = sender as! Channel
            let destinationVC = segue.destination as! ChatMessagesViewController
            destinationVC.sender = currentSender
            destinationVC.currentChannel = channel
        }
    }
    
    
}
