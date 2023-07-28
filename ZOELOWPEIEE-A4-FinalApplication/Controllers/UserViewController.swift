//
//  UserViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 11/05/2023.
//

import UIKit

///The `UserViewController` class represents a view controller responsible for managing user-related functionalities.
class UserViewController: UIViewController, DatabaseListener{

    //MARK: Properties
    var listenerType: ListenerType = .users
    weak var databaseController: DatabaseProtocol?
    
    //MARK: Lifecycle Methods
    /// This method is called after the view controller has loaded its view hierarchy into memory.
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
    }
    
    ///This method is called to perform necessary cleanup tasks just before the view is about to be removed from the screen.
    /// - Parameter animated: A boolean indicating whether the transition from the view will be animated.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //MARK: Actions
        
    /// Action method triggered when the user taps the sign-out button.
    /// - Parameter sender: The object that triggered the action.
    @IBAction func signOutAction(_ sender: Any) {
        let done = databaseController?.signOut() ?? false
        if done {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    //MARK: Not Implemented - not used
    func onAllChannelsChange(change: DatabaseChange, channels: [Channel], currentSender: Sender) {
        
    }
    
    func onAllTodosChange(change: DatabaseChange, todos: [ToDoListItem]) {
        
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
