//
//  ChatMessage.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 27/04/2023.
//

import UIKit
import MessageKit

/// A custom class representing a chat message conforming to the `MessageType` protocol.
class ChatMessage: MessageType {
    // MARK: - Properties
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    ///Initializes a new chat message with the specified parameters.
    /// - Parameters:
    ///    - sender: The sender of the message.
    ///    - messageId: The unique identifier of the message.
    ///    - sentDate: The date and time when the message was sent.
    ///    - message: The content of the message.
    init(sender: Sender, messageId: String, sentDate: Date, message: String) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = .text(message)
    }
}
