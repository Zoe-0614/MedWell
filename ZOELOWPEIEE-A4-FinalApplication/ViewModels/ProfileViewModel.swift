//
//  ProfileViewModel.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 11/05/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

protocol ProfileViewModelDelegate: AnyObject {
    func logout()
}

class ProfileViewModel: ObservableObject{
    
    // MARK: - Published Properties
    
    /// The database controller for managing database operations.
    @Published var databaseController: DatabaseProtocol?
    
    /// The name of the user.
    @Published var userName = ""
    
    /// The birth date of the user.
    @Published var birthDate = Date()
    
    /// Flag to indicate whether to show About Page.
    @Published var showAboutPage: Bool = false
    
    // MARK: - Other Properties
    
    /// The closure for the logout action.
    weak var delegate: ProfileViewModelDelegate?
    
    // MARK: - Initialization
    /// Initializes an instance of the `ProfileViewModel` class.
    init(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    /// This method is responsible for saving the user profile data.
    func saveUser(){
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        // Create a dictionary to represent the user profile data
        let userProfileData: [String: Any] = [
            "username": userName,
            "birthDate": birthDate
        ]
        
        // Save the user profile data to Firestore
        db.collection("users").document(uid).setData(userProfileData) { error in
            if let error = error {
                // Handle the error case
                print("Error saving user profile data: \(error.localizedDescription)")
            } else {
                // User profile data saved successfully
                print("User profile data saved successfully")
            }
        }
    }
    
    /// This method triggers the logout action.
    func signout(){
        do {
            try Auth.auth().signOut()
            
            // Call the delegate method to trigger the logout action in the hosting controller
            delegate?.logout()
            
        } catch {
            // Handle error during logout
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}
