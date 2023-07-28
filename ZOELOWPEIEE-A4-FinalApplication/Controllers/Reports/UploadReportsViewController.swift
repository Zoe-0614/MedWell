//
//  UploadReportsViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 18/05/2023.
//

import UIKit
import Photos
import CoreData

///The `UploadReportsViewController` class is responsible for managing the functionality related to uploading reports
class UploadReportsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var fileName: UITextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    /// Presents an alert controller with options to select a photo source: camera or photo library.
    /// - Parameter sender: The object that triggered the action.
    @IBAction func selectImage(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Photo", message: "Choose a source", preferredStyle: .actionSheet)
        // Camera Action
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        }
        // Gallery Action
        let galleryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.openGallery()
        }
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    /// Opens the camera for capturing a photo if available.
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                displayMessage(title: "Error", message: "Camera not available")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Opens the photo library for selecting an image.
    func openGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }

    // MARK: - Image Picker Delegate
    
    /// Called when an image is picked from the image picker controller.
    /// - Parameters:
    ///   - picker: The image picker controller.
    ///   - info: A dictionary containing the selected image and its metadata.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage.image = pickedImage
        }
        picker.dismiss(animated: true)
        
    }
    
    /// Called when the user cancels the image picker controller.
    /// - Parameter picker: The image picker controller.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    /// This method validates that an image is selected, generates a filename for the image, compresses the image data, and writes it to a file in the document directory.
    /// - Parameter sender: The button that triggered the action.
    @IBAction func saveAction(_ sender: Any) {
        guard let image = uploadImage.image else{
            self.displayMessage(title: "No image selected", message: "Please select an image")
            return
        }
        
        // Generate a filename for the image
        let timestamp = UInt(Date().timeIntervalSince1970)
        var filename = "\(timestamp).jpg"
        if !fileName.text!.isEmpty{
            filename = "\(fileName.text!).jpg"
        }
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Image data could not be compressed")
            return
        }
        
        let pathsList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = pathsList[0]
        let imageFile = documentDirectory.appendingPathComponent(filename)
        
        // Try to write the compressed image data to the file
        do {
            try data.write(to: imageFile)
            navigationController?.popViewController(animated: true)
        } catch {
        displayMessage(title: "Error", message: "\(error)")
        }
        
        // Pop view controller from the navigation stack
        navigationController?.popViewController(animated: true)
    }

}
    

