//
//  DatabaseProtocol.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 27/04/2023.
//

import Foundation

///The types of changes that can occur in the database.
enum DatabaseChange{
    //Indicates that a new item was added.
    case add
    //Indicates that an item was removed.
    case remove
    //Indicates that an item was updated.
    case update
}

///The types of listeners for database changes.
enum ListenerType{
    //Listener for channel changes.
    case channels
    //Listener for user changes.
    case users
    //Listener for todo item changes.
    case todos
    //Listener for all types of changes.
    case all
    
}

/// A protocol for database listeners to implement.
protocol DatabaseListener: AnyObject{
    var listenerType: ListenerType{get set}
    
    ///Notifies the listener when there are changes in the todo items.
    /// - Parameters:
    ///   - change: The type of change that occurred.
    ///   - todos: The updated list of todo items.
    func onAllTodosChange(change: DatabaseChange, todos: [ToDoListItem])
    
    /// Notifies the listener when there are changes in the channels.
    /// - Parameters:
    ///   - change: The type of change that occurred.
    ///   - channels: The updated list of channels.
    ///   - currentSender: The current sender of messages in the chat.
    func onAllChannelsChange(change: DatabaseChange, channels: [Channel], currentSender: Sender)
}

/// A protocol for the Firebase controller to implement.
protocol DatabaseProtocol: AnyObject {
    //Performs any necessary cleanup tasks when the app is terminated.
    func cleanup()

    // Adding and Removing Listeners
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    // Functions related to creating new reminders
    func deleteTodos(todos: ToDoListItem)
    func updateTodoItem(withId id: String, isDone: Bool)
    func setupTodosListener()
    func disposeTodosListener()
    
    // Functions related to creating chat messages
    func deleteChannels(channels: Channel)
    func setupChannelsListener()
    func disposeChannelsListener()
    func addChannel(channelName: String)
    
    
    // Functions related to authentication
    var firebaseAuthDelegate: FirebaseAuthDelegate? {get set}
    func login(email: String, loginPassword: String)
    func signup(email: String, signUpPassword:String)
    func signOut() -> Bool
}

/// A protocol for the FirebaseAuth delegate to implement.
protocol FirebaseAuthDelegate:AnyObject{
    /// Handles errors that occur during authentication.
    /// - Parameter error: The error that occurred.
    func error(_ error: NSError)
}




