//
//  FirebaseController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 27/04/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class FirebaseController: NSObject, DatabaseProtocol{
    
    // MARK: - Properties
    
    // Delegate for handling Firebase Authentication events
    var firebaseAuthDelegate: FirebaseAuthDelegate?
    // Multicast delegate for notifying database listeners
    var listeners = MulticastDelegate<DatabaseListener>()
    
    // Firebase Authentication and Firestore references
    var authController: Auth
    var database: Firestore
    
    // Firestore collection references
    var channelsRef: CollectionReference?
    var messagesRef: CollectionReference?
    var usersRef: CollectionReference?
    var todosRef: CollectionReference?
    
    // Current user and chat information
    var currentUser: FirebaseAuth.User?
    var channelList: [Channel]
    private var chatSnapshotListener: ListenerRegistration?
    private var channelSnapshotListener: ListenerRegistration?
    let DEFAULT_CHANNEL_NAME = "Channel"
    var sender: Sender?
    
    // Todo list information
    var todoList: [ToDoListItem]
    private var todosSnapshotListener: ListenerRegistration?
    let DEFAULT_TODO_NAME = "Todo"
    
    
    // MARK: - Initialization
    override init(){
        FirebaseApp.configure()
        authController = Auth.auth()
        currentUser = authController.currentUser
        database = Firestore.firestore()
        todoList = [ToDoListItem]()
        channelList = [Channel]()
        if let userId = self.currentUser?.uid {
            sender = Sender(id: userId, name: "Me")
        }
        print(sender?.senderId)
        super.init()
        
    }
    
    //MARK: Login, Signup and logout methods
    /// Signs out the current user from Firebase Authentication.
    /// - Returns: A boolean indicating whether the sign out was successful.
    func signOut() -> Bool {
        do {
            try authController.signOut()
            chatSnapshotListener?.remove()
            return true
        }
        catch {
            print("Can't sign out with error \(error)")
            return false
        }
    }
    
    /// Authenticates a user with the provided email and password and login to the app.
    /// - Parameters:
    ///    - email: The email of the user.
    ///    - loginPassword: The password of the user.
    func login(email: String, loginPassword: String) {
        
        authController.signIn(withEmail: email, password: loginPassword){result, error in
            
            if let e = error {
                self.firebaseAuthDelegate?.error(e as NSError)
                return
            }
            if let authDataResult = result {
                self.currentUser = authDataResult.user
                self.sender = Sender(id:  self.currentUser!.uid, name: "Me")
                print(self.sender?.senderId)
            }
        }
    }
    
    /// Creates a new user account with the provided email and password in the app.
    /// - Parameters:
    ///   - email: The email of the user.
    ///   - signUpPassword: The password of the user.
    func signup(email: String, signUpPassword: String) {
        authController.createUser(withEmail: email, password: signUpPassword){result, error in
            
            if let authDataResult = result {
                self.currentUser = authDataResult.user
                self.sender = Sender(id: self.currentUser!.uid, name: "Me")
                self.usersRef = self.database.collection("users")
                
            }
            
            if let e = error {
                self.firebaseAuthDelegate?.error(e as NSError)
                return
            }
            
        }
    }
    
    ///Removes a listener for database events.
    ///- Parameter listener: The listener to be removed.
    func removeListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
    
    ///Adds a listener for database events.
    ///- Parameter listener: The listener to be added.
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        if listener.listenerType == .todos || listener.listenerType == .all {
            listener.onAllTodosChange(change: .update, todos: todoList)
        }
        if listener.listenerType == .channels || listener.listenerType == .all {
            listener.onAllChannelsChange(change: .update, channels: channelList, currentSender: sender!)
        }
    }
    
    // MARK: Todos Methods
    
    /// Dispose the listeners after using it.
    func disposeTodosListener(){
        todosSnapshotListener?.remove()
    }
    
    /// Sets up the listener for todos changes in the Firestore database.
    func setupTodosListener(){
        let currentUser = authController.currentUser!
        todosRef = database.collection("users").document(currentUser.uid).collection("todos")
        
        todosSnapshotListener = todosRef?.whereField("name", isEqualTo: DEFAULT_TODO_NAME)
            .addSnapshotListener { querySnapshot, error in
                guard let querySnapshot = querySnapshot
                else {
                    print("Error fetching todos: \(String(describing: error))")
                    return
                }
                
                self.parseTodosSnapshot(snapshot: querySnapshot)
            }
    }
    
    /// Parses the Firestore snapshot for todos and updates the todo list.
    /// - Parameter snapshot: The snapshot from the Firestore database.
    func parseTodosSnapshot(snapshot: QuerySnapshot) {
        
        // treat data manually as dictionary
        snapshot.documentChanges.forEach{ (change) in
            // only pay attention to changes -- added, modified, removed
            // Note that the first time this snapshot is called during each application launch,
            // it will treat all existing records as being added.
            
            // parse data
            var parsedTodo: ToDoListItem?
            do {
                parsedTodo = try change.document.data(as: ToDoListItem.self)
            } catch {
                print("Unable to decode todo.")
                return
            }
            
            guard let todo = parsedTodo else {
                print("Document doesn't exist")
                return
            }
            
            // handle types
            if change.type == .added {
                todoList.insert(todo, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                todoList[Int(change.oldIndex)] = todo
            }
            else if change.type == .removed {
                todoList.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.todos || listener.listenerType == ListenerType.all {
                    listener.onAllTodosChange(change: .update, todos: todoList)
                }
            }
        }
    }
    
    /// Updates the status of a todo item with the given ID in the database.
    /// - Parameters:
    ///    - id: The ID of the todo item to update.
    ///    - isDone: The new status of the todo item (true for completed, false for incomplete).
    func updateTodoItem(withId id: String, isDone: Bool) {
        let currentUser = authController.currentUser!
        let todosRef = database.collection("users").document(currentUser.uid).collection("todos").document(id)
        
        todosRef.updateData(["isDone": isDone]) { error in
            if let error = error {
                print("Error updating todo item: \(error.localizedDescription)")
            } else {
                print("Todo item updated successfully.")
            }
        }
    }
    
    /// Deletes a todo item from the Firestore database.
    ///     - Parameter todos: The todo item to be deleted.
    func deleteTodos(todos: ToDoListItem){
        if let todosId = todos.id {
            todosRef?.document(todosId).delete()
        }
    }
    
    
    // MARK: - Channels Methods
        
    ///Adds a new channel to the Firestore database.
    ///- Parameter channelName: The name of the channel to be added.
    func addChannel(channelName: String) {
        channelsRef = database.collection("users").document(currentUser!.uid).collection("channels")
        
        let channelData: [String: Any] = [
            "name": channelName,
            "firebaseName": "Channel"
        ]
        
        channelsRef?.addDocument(data: channelData) { error in
            if let error = error {
                // Handle the error
                print("Failed to add channel: \(error.localizedDescription)")
                return
            }
            
            // The channel was successfully added to Firestore
            print("Channel added successfully")
        }
    }
    
    
    ///Deletes a channel from the Firestore database.
    ///- Parameter channels: The channel to be deleted.
    func deleteChannels(channels: Channel) {
        if let channelsId = channels.id {
            channelsRef?.document(channelsId).delete()
        }
    }
    
    /// Sets up the listener for channels changes in the Firestore database.
    func setupChannelsListener() {
        self.channelList.removeAll()
        let currentUser = authController.currentUser!
        print(currentUser.uid)
        channelsRef = database.collection("users").document(currentUser.uid).collection("channels")
        
        channelSnapshotListener = channelsRef?.whereField("firebaseName", isEqualTo: DEFAULT_CHANNEL_NAME)
            .addSnapshotListener { querySnapshot, error in
                guard let querySnapshot = querySnapshot
                        //let todosSnapshot = querySnapshot.documents.first
                else {
                    print("Error fetching todos: \(String(describing: error))")
                    return
                }
                
                self.parseChannelsSnapshot(snapshot: querySnapshot)
            }
    }
    
    /// Parses the Firestore snapshot for channels and updates the channel list.
    /// - Parameter snapshot: The snapshot from the Firestore database.
    func parseChannelsSnapshot(snapshot: QuerySnapshot) {
        // treat data manually as dictionary
        snapshot.documentChanges.forEach{ (change) in
            // only pay attention to changes -- added, modified, removed
            // Note that the first time this snapshot is called during each application launch,
            // it will treat all existing records as being added.
            
            // parse data
            var parsedChannel: Channel?
            do {
                parsedChannel = try change.document.data(as: Channel.self)
            } catch {
                print("Unable to decode channel.")
                return
            }
            
            guard let channel = parsedChannel else {
                print("Document doesn't exist")
                return
            }
            
            // handle types
            if change.type == .added {
                channelList.insert(channel, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                channelList[Int(change.oldIndex)] = channel
            }
            else if change.type == .removed {
                channelList.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.channels || listener.listenerType == ListenerType.all {
                    listener.onAllChannelsChange(change: .update, channels: channelList, currentSender: sender!)
                }
            }
        }
        
    }
    
    /// Dispose the listener after using it.
    func disposeChannelsListener() {
        channelSnapshotListener?.remove()
    }
    
    //Not implemented - not used
    func cleanup() {
    }
    
}

