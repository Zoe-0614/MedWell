//
//  ChatMessagesViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 27/04/2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

/// The view controller responsible for displaying chat messages.
class ChatMessagesViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate,InputBarAccessoryViewDelegate {

    // MARK: - Properties
    var sender: Sender?
    var currentChannel: Channel?
    var messagesList = [ChatMessage]()
    var channelRef: CollectionReference?
    var databaseListener: ListenerRegistration?
    
    /// The date formatter used to format message timestamps.
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm dd/MM/yy"
        return formatter
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        // Do any additional setup after loading the view.
        if currentChannel != nil {
            let database = Firestore.firestore()
            channelRef = database.collection("users").document(currentSender().senderId).collection("channels").document(currentChannel!.id!).collection("messages")
            if let name = currentChannel?.name{
                navigationItem.title = "\(name)"
            }
            print(currentSender().senderId)
        }
    }
    
    /// Overrides the `viewWillAppear` method of the superclass to set up a listener for real-time updates from the Firestore database.
    /// This method is called automatically when the view is about to appear on the screen.
    /// - Parameter animated: A Boolean value indicating whether the view will be presented with animation.
    override func viewWillAppear(_ animated: Bool) {
        databaseListener = channelRef?.order(by: "time").addSnapshotListener() { (querySnapshot, error) in
            if let error = error { print(error)
                return
            }
            
            querySnapshot?.documentChanges.forEach() { change in
                if change.type == .added {
                    let snapshot = change.document
                    let id = snapshot.documentID
                    let senderId = snapshot["senderId"] as! String
                    let senderName = snapshot["senderName"] as! String
                    let messageText = snapshot["text"] as! String
                    let sentTimestamp = snapshot["time"] as! Timestamp
                    let sentDate = sentTimestamp.dateValue()
                    let sender = Sender(id: senderId, name: senderName)
                    let message = ChatMessage(sender: sender, messageId: id, sentDate: sentDate, message: messageText)
                    self.messagesList.append(message)
                    self.messagesCollectionView.insertSections([self.messagesList.count-1])
                }
            }
        }
    }
    
    /// Overrides the `viewWillDisappear` method of the superclass to remove the database listener to stop receiving real-time updates.
    /// This method is called automatically when the view is about to disappear from the screen
    /// - Parameter animated: A Boolean value indicating whether the view will be dismissed with animation.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseListener?.remove()
    }
    
    /// The current sender of the chat messages.
    /// - Returns: An instance of `Sender` representing the current sender.
    func currentSender() -> MessageKit.SenderType {
        if let currentsender = sender{
            return currentsender
        }
        return Sender(id: "", name: "")
    }
    
    
    /// This method is called by the `MessagesCollectionView` to retrieve the message at the given index path.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the message.
    ///   - messagesCollectionView: The `MessagesCollectionView` requesting the message.
    /// - Returns: The message at the specified index path.
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messagesList[indexPath.section]
    }

    /// This method is called by the `MessagesCollectionView` to determine the number of sections in the collection view.
    /// In this implementation, it returns the count of the `messagesList` array, which represents the number of chat messages.
    /// - Parameter messagesCollectionView: The `MessagesCollectionView` requesting the number of sections.
    /// - Returns: The number of sections in the collection view.
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messagesList.count
    }
    
    /// This method is called by the `MessagesCollectionView` to obtain the attributed text for the top label of a chat message at the specified index path.
    /// - Parameters:
    ///   - message: The chat message for which to retrieve the top label attributed text.
    ///   - indexPath: The index path of the chat message in the collection view.
    /// - Returns: The attributed text for the top label of the chat message, or `nil` if not applicable.
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font:UIFont.preferredFont(
            forTextStyle: .caption1)])
    }
    
    /// This method is called by the `MessagesCollectionView` to obtain the attributed text for the bottom label of a chat message at the specified index path.
    /// - Parameters:
    ///   - message: The chat message for which to retrieve the bottom label attributed text.
    ///   - indexPath: The index path of the chat message in the collection view.
    /// - Returns: The attributed text for the bottom label of the chat message, or `nil` if not applicable.
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font:UIFont.preferredFont(
            forTextStyle: .caption2)])
    }
    

    /// This method is called when the send button is pressed on the input bar.
    /// The method first checks if the text is empty, and if so, it returns early without performing any action.
    /// If the text is not empty, it adds a new document to the `channelRef` collection with the necessary data, including the sender ID, sender name, text, and the current timestamp.
    /// - Parameters:
    ///   - inputBar: The input bar accessory view.
    ///   - text: The entered text.
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if text.isEmpty {
            return
        }
        channelRef?.addDocument(data: [
            "senderId" : sender!.senderId,
            "senderName" : sender!.displayName,
            "text" : text,
            "time" : Timestamp(date: Date.init())
        ])
        inputBar.inputTextView.text = ""
    }
    
    /// This method is called to determine the height of the top label for a specific cell.
    /// - Parameters:
    ///   - message: The message for which the top label height is being calculated.
    ///   - indexPath: The index path of the message in the messages collection view.
    ///   - messagesCollectionView: The messages collection view.
    /// - Returns: The height of the top label.
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
        return 18
    }
    
    /// This method is called to determine the height of the bottom label for a specific cell.
    /// - Parameters:
    ///   - message: The message for which the bottom label height is being calculated.
    ///   - indexPath: The index path of the message in the messages collection view.
    ///   - messagesCollectionView: The messages collection view.
    /// - Returns: The height of the bottom label.
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
        return 17
    }
    
    /// This method is called to determine the height of the top label for a specific message cell.
    /// - Parameters:
    ///   - message: The message for which the top label height is being calculated.
    ///   - indexPath: The index path of the message in the messages collection view.
    ///   - messagesCollectionView: The messages collection view.
    /// - Returns: The height of the top label.
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
        return 20
    }
    
    /// This method is called to determine the height of the bottom label for a specific message cell.
    /// The method simply returns a constant height value of 16.
    /// - Parameters:
    ///   - message: The message for which the bottom label height is being calculated.
    ///   - indexPath: The index path of the message in the messages collection view.
    ///   - messagesCollectionView: The messages collection view.
    /// - Returns: The height of the bottom label.
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
        return 16
    }
    
    /// This method is called to determine the style of the message bubble for a specific message cell.
    /// The method checks whether the message is from the current sender or not using the `isFromCurrentSender(message:)` method. If the message is from the current sender, it sets the bubble tail corner to `.bottomRight`; otherwise, it sets it to `.bottomLeft`.
    /// - Parameters:
    ///   - message: The message for which the message style is being determined.
    ///   - indexPath: The index path of the message in the messages collection view.
    ///   - messagesCollectionView: The messages collection view.
    /// - Returns: The style of the message bubble.
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
        
    }
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
  
     }
     
    
}
