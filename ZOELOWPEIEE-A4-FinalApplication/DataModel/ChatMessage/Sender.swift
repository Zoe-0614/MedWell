//
//  Sender.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 27/04/2023.
//

import UIKit
import MessageKit

/// A class representing a sender in a chat application.
class Sender: SenderType {
    //MARK: - Properties
    var senderId: String
    var displayName: String
    
    ///Initializes a new instance of the Sender class
    ///- Parameters:
    ///   - id: The unique identifier of the sender.
    ///   - name: The display name of the sender.
    init(id: String, name: String) {
        self.senderId = id
        self.displayName = name
    }
}
