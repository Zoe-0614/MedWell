//
//  NewsDetailsViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 01/06/2023.
//

import UIKit

/// A view controller that displays the details of a news item.
class NewsDetailsViewController: UIViewController {
    
    //MARK: - Properties
    var news: NewsData?
    var indicator = UIActivityIndicatorView()
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //MARK: - Lifecyle Method
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the loading indicator
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
        
        // Load the news image if the URL is available
        if let requestUrlString = news?.image,
           let requestUrl = URL(string: requestUrlString) {
            self.indicator.startAnimating()
            
            // Download the image asynchronously
            URLSession.shared.dataTask(with: requestUrl){
                data, response, error in
                
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                if let error = error {
                    print("Failed to download image: \(error)")
                    return
                }
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        } else{
            print("Image URL is nil")
        }
        
        // Update the labels with news details
        titleLabel?.text = news?.title
        authorLabel?.text = news?.author
        // Join the category strings and display them
        if let category = news?.category?.joined(separator: ", "){
            categoryLabel?.text = category
        }
        publishedLabel?.text = news?.published
        descriptionLabel?.text = news?.newsDescription
        
    }
    
    
    
    
}
