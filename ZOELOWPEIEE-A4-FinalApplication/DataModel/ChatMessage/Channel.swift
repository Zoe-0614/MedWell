//
//  Channel.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 27/04/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

/// A struct representing a channel in the chat.
struct Channel: Codable, Identifiable {
    // MARK: - Properties
    @DocumentID var id: String?
    let name: String?
    let firebaseName: String?
}

/// The coding keys for the Channel struct.
enum ChannelKeys: String, CodingKey{
    case id
    case firebaseName
    case name
}

