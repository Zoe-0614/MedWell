//
//  ProfileView.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 11/05/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// The view for the user's profile settings.
struct ProfileView: View{
    // State object for the profile view model
    @StateObject var viewModel = ProfileViewModel()
    // State variable for storing username
    @State private var userName = ""
    // State variable for storing birthdate
    @State private var birthDate = Date()

    var body: some View{
        NavigationView{
            Form{
                Section(header: Text( "Personal Information")){
                    // Text field for entering the user name
                    TextField("User Name", text: $viewModel.userName)
                    // DatePicker for selecting the birth date
                    DatePicker("BirthDate", selection: $viewModel.birthDate, displayedComponents: .date)
                }
                
                Section(header: Text("Actions")){
                    // Link to the Terms of Service page
                    Link("Terms of Service",destination: URL(string: "https://policies.google.com/terms?hl=en")!)
                }
                
                Section{                    
                    HStack{
                        // Icon image
                        Image(systemName: "hand.raised.fill")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        // About page picker options
                        Button(action:{ viewModel.showAboutPage.toggle()}, label: {
                            // Button to log out the user
                            Text("About Page").foregroundColor(.black)
                        })
                        //Link to About page
                        NavigationLink(destination: AboutPageView(), isActive: $viewModel.showAboutPage) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }
                
                Section{
                    Button(action: { viewModel.signout() }, label: {
                        // Button to log out the user
                        Text("Logout")
                    })
                }
            }
            .navigationTitle("Account")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    // Button to save the user profile
                    Button("Save", action: viewModel.saveUser)
                }
            }
        }
    }
}


/// Preview
struct ProfileView_Previews: PreviewProvider{
    static var previews: some View{
        ProfileView()
    }
}

/// Protocol for logout action.
protocol logout {
    func signOutAction()
}

/// Hosting controller for the ProfileView.
class ProfileViewHostingController:  UIHostingController<ProfileView>, DatabaseListener, logout, ProfileViewModelDelegate{
    
    // MARK: - Properties
    required init? (coder: NSCoder){
        super.init(coder: coder, rootView: ProfileView())
    }
    var listenerType: ListenerType = .users
    weak var databaseController: DatabaseProtocol?
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    /// Add listener when view appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    /// Remove listener when view disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    /// Sign out from the app
    func signOutAction() {
        let done = databaseController?.signOut() ?? false
        if done {
            navigationController?.popViewController(animated: true)
        }
        
    }
    /// Not implemented - not used
    func onAllTodosChange(change: DatabaseChange, todos: [ToDoListItem]) {
    }
    
    func onAllChannelsChange(change: DatabaseChange, channels: [Channel], currentSender: Sender) {
    }
    
    func logout() {
        let loginViewController = LoginViewController()
        self.dismiss(animated: true) {
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
