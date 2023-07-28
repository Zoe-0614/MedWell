//
//  ShowReportViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Soo yew Lim on 31/05/2023.
//

import UIKit

/// The view controller is responsible for displaying a report.
class ShowReportViewController: UIViewController {
    @IBOutlet weak var showImage: UIImageView!
    
    //MARK: - Properties
    var fileName : String? = ""
    
    // MARK: - Lifecyle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// Sets up the view before it appears on the screen.
    /// - Parameter animated: A Boolean value indicating whether the appearance is animated.
    override func viewWillAppear(_ animated: Bool) {
        do {
            navigationItem.title = fileName
            
            if let image = loadImageData() {
                showImage.image = image
            }
        } catch {
            print("Unable to fetch images")
        }
    }
    
    //MARK: - Actions
    
    /// Loads the image data from the file.
    /// - Returns: The loaded image, or nil if loading fails.
    func loadImageData() -> UIImage? {
        // Get the paths for the document directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        // Create the file URL by appending the file name to the document directory path
        let imageURL = documentsDirectory.appendingPathComponent(fileName!)
        // Load the image from the file URL
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    
    
    /// Performs the share action for the displayed image.
    /// - Parameter sender: The object that initiated the action.
    @IBAction func shareAction(_ sender: Any) {
        let image = loadImageData()
        
        // Create an array of items to share
        let shareItems: [Any] = [image]
        
        // Create an instance of UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        // Present the activityViewController
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
