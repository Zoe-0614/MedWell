//
//  StatisticsViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Soo yew Lim on 11/05/2023.
//

import UIKit

/// This view controller displays the overall statistics of the user.
class StatisticsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    //MARK: - Properties
    let colors: [UIColor] = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
    let titles = [" Calories Burned", " Sleep Hours", " Weight Records", " BPM Records "]
    let descriptions = ["The count of calories burned with your activity throughout the day", "It takes the count of the hours in bed of the last night", "Your last weight measurement on kilograms", "A record of beats per minute is recorded in different activities"]
    let shortDescription = ["The count of calories burned", "The count of hours in bed ", "Your last weight measurement on kilograms", "A record of beats per minute"]
    var cardInfoLabel = ["771", "8 h", "44.3 kg", "71 BPM" ]
    let quickTitles = ["Height", "Gender", "Blood Type"]
    let hourlyRecordsLabel = ["8 am", "9 am", "10 am", "11 am", "12 pm", "1 pm",
        "2 pm", "3 pm", "4 pm", "5 pm", "6 pm", "7 pm", "8 pm"]
    let dailyRecordsLabel = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    var recordsLabel: [[String]] = []
    let caloriesValues:[Double] = [405, 420, 500, 320, 850, 830, 680, 603, 705, 809, 490, 381 ,771]
    let sleepValues:[Double] = [7,8,5,7,8,8,7]
    let weightValues:[Double] = [43.8, 44.0, 43.4, 43.8, 44.3, 43.8, 43.7]
    let bpmValues:[Double] = [70, 120, 100, 80, 85, 83, 68, 65, 75, 89, 90, 81 ,71]
    var recordsValues:[[Double]] = []
    let images: [UIImage] = [#imageLiteral(resourceName: "burn-icon"), #imageLiteral(resourceName: "moon-icon"), #imageLiteral(resourceName: "weight-icon"), #imageLiteral(resourceName: "hearth-icon")]
    var detailLabels: [String]?
    var userGender: String = "Female"
    var userBloodType: String = "A+"
    var healthKitAvailable = false
    let user = User()
    
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setTransparent()
        
        // Request authorization for HealthKit data
        HealthKitService.shared.requestDataTypes { (error) in
            if let error = error {
                print(error)
                // Handle authorization error
            } else {
                self.getBasicHealthKitData()
            }
        }
        
        if let gender = self.user.biologicalSex{
            userGender = gender
        }
        
        if let bloodType = self.user.bloodType{
            userBloodType = bloodType
        }
        
        detailLabels = ["150", userGender, userBloodType]
        recordsLabel = [hourlyRecordsLabel, dailyRecordsLabel, dailyRecordsLabel, hourlyRecordsLabel]
        recordsValues = [caloriesValues, sleepValues, weightValues, bpmValues]
    }
    
    // MARK: - Private Methods
    
    ///This method is used to retrieve basic health data from HealthKit and updating the user's properties
    private func getBasicHealthKitData() {
        // Get biological sex formatted
        self.getBiologicalSexFormatted { (biologicalSexString) in
            if let biologicalSex = biologicalSexString {
                self.user.biologicalSex = biologicalSex
            }
            // Get blood type formatted
            self.getBloodTypeFormatted { (bloodTypeString) in
                if let bloodType = bloodTypeString {
                    self.user.bloodType = bloodType
                }
                // Get birthday date
                HealthKitService.shared.getBirthdayDate { (date, _) in
                    if let date = date {
                        self.user.birthday = date
                    }
                    // Reload collection view on the main queue
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    /// Retrieves the formatted string for the user's biological sex from HealthKit.
    ///- Parameter handler: A closure to handle the retrieved biological sex string. The string is passed as an optional parameter to the closure.
    private func getBiologicalSexFormatted(handler: @escaping (_ birthDate: String?) -> Void) {
        HealthKitService.shared.getBiologicalSex { (biologicalSex, _) in
            var biologicalSexString = ""
            if let biologicalSex = biologicalSex {
                switch biologicalSex.biologicalSex {
                case .notSet:
                    biologicalSexString = "Not Set"
                case .female:
                    biologicalSexString = "Female"
                case .male:
                    biologicalSexString = "Male"
                case .other:
                    biologicalSexString = "Other"
                @unknown default:
                    biologicalSexString = "Unknown"
                }
                handler(biologicalSexString)
                return
            }
            handler(nil)
        }
    }
    
    /// Retrieves the formatted string for the user's blood type from HealthKit.
    ///- Parameter handler: A closure to handle the retrieved blood type string. The string is passed as an optional parameter to the closure.
    private func getBloodTypeFormatted(handler: @escaping (_ bloodType: String?) -> Void) {
        HealthKitService.shared.getBloodType { (bloodType, _) in
            if let bloodType = bloodType {
                var bloodTypeString = ""
                switch bloodType.bloodType {
                case .notSet:
                    bloodTypeString = "Not Set"
                case .aPositive:
                    bloodTypeString = "A+"
                case .aNegative:
                    bloodTypeString = "A-"
                case .bPositive:
                    bloodTypeString = "B+"
                case .bNegative:
                    bloodTypeString = "B-"
                case .abPositive:
                    bloodTypeString = "AB+"
                case .abNegative:
                    bloodTypeString = "AB-"
                case .oPositive:
                    bloodTypeString = "O+"
                case .oNegative:
                    bloodTypeString = "O-"
                @unknown default:
                    bloodTypeString = "Unknown"
                }
                handler(bloodTypeString)
            }
            handler(nil)
        }
    }
    
    //MARK: - Collection View
    /// This method is called when the view controller's view is about to transition to a new size
    ///- Parameters:
    ///  - size: The new size for the view's bounds.
    ///  - coordinator: The transition coordinator object managing the size change.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    ///This method checks if the selected item is in section 1 and performs a segue with the specified identifier "showRecordsSegue" to navigate to the corresponding view controller.
    ///- Parameters:
    ///   - collectionView: The collection view object that is notifying the delegate about the selection change.
    ///   - indexPath: The index path of the selected item.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "showRecordsSegue", sender: nil)
        }
    }
    
    // MARK: UICollectionViewDataSource
    /// This method is called by the collection view to determine the number of sections it should display.
    /// - Parameter collectionView: The collection view requesting this information.
    /// - Returns: The number of sections in the collection view.
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// This method checks the value of the `section` parameter and returns the appropriate count based on the section index.
    /// - Parameters:
    ///    - collectionView: The collection view requesting this information.
    ///    - section: The index of the section for which to return the item count.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If `section` is 0, it returns the count of `quickTitles` array.
        // If `section` is 1, it returns the count of `titles` array.
        var sections = 0
        if section == 0 {
            sections = self.quickTitles.count
        } else if section == 1{
            sections = self.titles.count
        }
        
        return sections
    }
    
    /// This method is called by the collection view to retrieve the cell that should be displayed for the item at the specified index path.
    /// - Parameters:
    ///    - collectionView: The collection view requesting this information.
    ///    - indexPath: The index path that specifies the location of the item.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // If the section is 0, it dequeues and configures a cell of type `QuickInfoCollectionViewCell` using the "QuickInfoCell" reuse identifier.
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickInfoCell", for: indexPath) as! QuickInfoCollectionViewCell
            // Sets the cell's `titleLabel` text to the corresponding title from the `quickTitles` array.
            cell.titleLabel.text = self.quickTitles[indexPath.row]
            if let details = self.detailLabels{
                cell.detailLabel.text = details[indexPath.row]
            }
            return cell
        } else {
            // If the section is any other value, it dequeues and configures a cell of type `CardCollectionViewCell` using the "CardCell" reuse identifier.
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
            // Sets the cell's `titleLabel` text, `descriptionLabel` text, `iconImageView` image, and `gradientView` background colors based on the corresponding data respectively.
            cell.titleLabel.text = self.titles[indexPath.row]
            cell.descriptionLabel.text = self.descriptions[indexPath.row]
            cell.infoLabel.text = self.cardInfoLabel[indexPath.row]
            let color = self.colors[indexPath.row]
            cell.gradientView.firstColor = color
            cell.gradientView.secondColor = color
            cell.gradientView.backgroundColor = self.colors[indexPath.row]
            return cell 
        }
    }
    

    // MARK: UICollectionViewDelegateFlowLayout
    
    /// This method is called by the collection view's layout object to determine the size of the specified item's cell.
    /// - Parameters:
    ///    - collectionView: The collection view requesting this information.
    ///    - collectionViewLayout: The layout object requesting the size information.
    ///    - indexPath: The index path of the item.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Calculates the height and width based on the current device's orientation and the section of the item.
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        let device = UIDevice.current
        
        if indexPath.section == 0 {
            if device.orientation.isLandscape {
                return CGSize(width: width * 0.1, height: width * 0.1)
            }
            return CGSize(width: width * 0.13, height: width * 0.13)
        } else {
            if device.orientation.isLandscape {
                return CGSize(width: width * 0.47, height: height * 0.4)
            }
            return CGSize(width: width * 0.9, height: height * 0.22)
        }
    }
    
     //Override the prepare method to handle the segue preparation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showRecordsSegue" {
                // Cast the destination view controller to the appropriate type
                if let destinationVC = segue.destination as? RecordViewController {
                    // Get the sender data and pass it to the destination view controller
                    if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                        destinationVC.labelTitle = titles[indexPath.row]
                        destinationVC.labelDescription = shortDescription[indexPath.row]
                        destinationVC.icon = images[indexPath.row]
                        destinationVC.recordsLabel = recordsLabel[indexPath.row]
                        destinationVC.recordsValue = recordsValues[indexPath.row]
                    }
                }
            }
        }
    
}
