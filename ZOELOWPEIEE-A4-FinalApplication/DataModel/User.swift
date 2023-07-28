//
//  User.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 19/04/2023.
//

import UIKit
import FirebaseFirestoreSwift

/// A class representing a user.
class User {
    private var _firstName: String
    private var _lastName: String
    private var _age: Int?
    private var _bloodType: String?
    private var _birthDay: Date?
    private var _biologicalSex: String?
    
    // Initializes a new User object with default values for first name and last name.
    init() {
        self._firstName = "First"
        self._lastName = "Last"
    }
    
    var firstName: String {
        set { self._firstName = newValue    }
        get { return self._firstName        }
    }
    
    var lastName: String {
        set { self._lastName = newValue     }
        get { return self._lastName         }
    }
    
    var fullName: String { return "\(self._firstName) \(self._lastName)"}
    
    var biologicalSex: String? {
        set { self._biologicalSex = newValue    }
        get { return self._biologicalSex        }
    }
    
    var birthday: Date? {
        set { self._birthDay = newValue }
        get { return self._birthDay     }
    }
    
    var bloodType: String? {
        set { self._bloodType = newValue    }
        get { return self._bloodType        }
    }
}
