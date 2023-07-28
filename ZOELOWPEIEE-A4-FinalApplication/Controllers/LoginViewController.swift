//
//  LoginViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 20/04/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

/// The LoginViewController class is responsible for handling user authentication and providing login and signup functionality.
class LoginViewController: UIViewController, FirebaseAuthDelegate, ProfileViewModelDelegate {

    
    // MARK: - Properties
    let scrollView = UIScrollView()
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var logo: UIImageView!
    let LOGIN_SEGUE = "loginSegue"
    weak var databaseController: DatabaseProtocol?
    var authHandler: AuthStateDidChangeListenerHandle?
    var authController = Auth.auth()
    var sender: Sender?
    let profileViewModel = ProfileViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the view and set up initial configuration
        let image = UIImage(named: "MedWell.png")
        logo.image = image
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Do any additional setup after loading the view
        emailText.autocorrectionType = .no
        passwordText.isSecureTextEntry = true
        
        databaseController?.firebaseAuthDelegate = self
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
        
        navigationController?.isNavigationBarHidden = true
        
        // Assign the delegate to self
        profileViewModel.delegate = self
    }
    
    // MARK: - Keyboard Handling
    /// Handles keyboard appearance
    /// This method adjusts the content inset and scroll indicator inset of the scroll view to accommodate the keyboard height.
    /// - Parameter notification: The notification object containing information about the keyboard.
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    /// Handles the disappearance of the keyboard.
    /// This method resets the content inset and scroll indicator inset of the scroll view to zero.
    /// - Parameter notification: The notification object containing information about the keyboard.
    func keyboardWillHide(_ notification: Notification) {
        // Handle keyboard disappearance
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Deinitialization
    /// Deinitializes the LoginViewController instance.
    /// This method removes the view controller from observing keyboard-related notifications.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// Add authentication listener when the view will appear
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.addAuthListener()
    }
    
    /// Remove authentication listener when the view will disappear/
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeAuthListener()
    }
    
    // MARK: - Authentication
    /// This method adds a listener to the authentication controller to check if a user is signed in.
    /// If a user is signed in, it sets the sender information and performs a segue to the next view controller.
    func addAuthListener() {
        authHandler = authController.addStateDidChangeListener { (auth, user) in
            if let user = user, let _ = user.email {
                print("User is signed in with uid:", user.uid)
                self.sender = Sender(id: user.uid, name:"Me")
                self.performSegue(withIdentifier: self.LOGIN_SEGUE, sender: nil)
            } else {
                print("No user is signed in.")
            }
        }
    }
    
    /// This method removes the previously added authentication listener, stopping it from monitoring the user sign-in state.
    func removeAuthListener() {
        authController.removeStateDidChangeListener(authHandler!)
    }

    
    // MARK: - Input Validation
    /// Validates whether the provided email address is in a valid format.
    /// - Parameter email: The email address to be validated.
    /// - Returns: A Boolean value indicating whether the email is valid or not. Returns `true` if the email is valid, otherwise returns `false`.
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Button Actions
    /// Handles the action when the login button is tapped.
    /// It retrieves the email and password entered in the corresponding text fields.
    /// If any of the fields are empty or if the email is not valid, it displays an error message.
    /// Otherwise, it calls the `login` method on the `databaseController` object, passing the email and password for authentication.
    /// - Parameter sender: The object that triggered the action.
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text
        else {
            return
        }
        
        if email.isEmpty || password.isEmpty {
            let errorMsg = "Please ensure all fields are filled."
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        
        if !isValidEmail(email) {
            displayMessage(title: "Invalid email", message: "Email address is not valid")
            return
        }
        
        let _ = databaseController?.login(email: email, loginPassword: password)
        
    }
    
    
    /// Handles the action when the signup button is tapped.
    /// It retrieves the email and password entered in the corresponding text fields.
    /// If any of the fields are empty or if the email is not valid, it displays an error message.
    /// Otherwise, it calls the `signup` method on the `databaseController` object, passing the email and password for signup.
    /// - Parameter sender: The object that triggered the action.
    @IBAction func signupAction(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text
        else {
            return
        }
        
        if email.isEmpty || password.isEmpty {
            let errorMsg = "Please ensure all fields are filled"
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        
        if !isValidEmail(email) {
            displayMessage(title: "Invalid email", message: "Email address is not valid")
            return
        }
        
        let _ = databaseController?.signup(email: email, signUpPassword: password)
    }
    
    // MARK: - Error Handling
    /// This method is called to handle an error and display an alert with the error message.
    /// - Parameter error: The error to be handled.
    func error(_ error: NSError) {
        displayMessage(title: "Error", message: error.localizedDescription)
    }
    
    
    // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         
     }
    
    //Not implemented
    func logout() {
        self.dismiss(animated: true, completion: nil)
    }
    
     
    
}


