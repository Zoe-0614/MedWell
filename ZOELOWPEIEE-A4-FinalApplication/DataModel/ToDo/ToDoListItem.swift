//
//  TodoListItem.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 11/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

/// A struct representing a to-do list item.
struct ToDoListItem: Codable, Identifiable{
    // MARK: - Properties
    @DocumentID var id: String?
    let title: String?
    let description: String?
    let dueDate: Date?
    let createdDate: Date?
    var isDone: Bool
    var name: String?
    
    /// Sets the completion state of the to-do item.
    /// - Parameter state: The new completion state.
    mutating func setDone(_ state: Bool){
        isDone = state
    }
}

/// The coding keys for the ToDoListItem struct.
enum CodingKeys: String, CodingKey{
    case id
    case title
    case dueDate
    case createdDate
    case isDone
    case name
}

