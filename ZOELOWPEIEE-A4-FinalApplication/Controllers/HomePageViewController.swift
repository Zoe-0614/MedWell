//
//  HomePageViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 20/04/2023.
//

import UIKit

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - Properties
    let SEGUE_HOME = "homeSegue"
    var currentUser: Sender?
    
    //MARK: - Outlets
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var showNewsTableView: UITableView!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let date = Date()
        let dateFormatter = DateFormatter()
        // Set the desired date format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = dateFormatter.string(from: date)
        dateTime.text = dateString
        
        showNewsTableView.delegate = self
        showNewsTableView.dataSource = self
        
        statusCollectionView.delegate = self
        statusCollectionView.dataSource = self
        
        

    }
    
    // MARK: - UITableViewDataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the number of rows in each table view
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Dequeue the appropriate cell based on the table view and index path
            if tableView == showNewsTableView {
                // Configure the cell for showNewsTableView
                let cell = tableView.dequeueReusableCell(withIdentifier: "linkNewsCell", for: indexPath)
                
                return cell
            }

            return UITableViewCell()
        }

        // MARK: - UITableViewDelegate
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Handle cell selection for each table view separately
            if tableView == showNewsTableView {
                // Handle cell selection for showNewsTableView
                // Navigate to the corresponding view or perform any other action
                performSegue(withIdentifier: "homeToNewsSegue", sender: nil)
            }
        }
    
    
    // MARK: UICollectionViewDataSource
    /// This method is called by the collection view to determine the number of sections it should display.
    /// - Parameter collectionView: The collection view requesting this information.
    /// - Returns: The number of sections in the collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == statusCollectionView{
            return 1
        }
        return 0
    }

    /// This method checks the value of the `section` parameter and returns the appropriate count based on the section index.
    /// - Parameters:
    ///    - collectionView: The collection view requesting this information.
    ///    - section: The index of the section for which to return the item count.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == statusCollectionView{
            return 4
        }
        return 0
    }
    
    /// This method is called by the collection view to retrieve the cell that should be displayed for the item at the specified index path.
    /// - Parameters:
    ///    - collectionView: The collection view requesting this information.
    ///    - indexPath: The index path that specifies the location of the item.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == statusCollectionView{
            // If the section is 0, it dequeues and configures a cell of type `CaloriesCollectionViewCell` using the "caloriesCell" reuse identifier.
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "caloriesCell", for: indexPath) as! CaloriesCollectionViewCell
                cell.dataLabel.text = "1708"
                return cell
            } else if indexPath.row == 1 {
                // If the section is any other value, it dequeues and configures a cell of type `WeightCollectionViewCell` using the "weightCell" reuse identifier.
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weightCell", for: indexPath) as! WeightCollectionViewCell
                cell.dataLabel.text = "43.8 kg"
                cell.analysisLabel.text = "0.3 kg less"
                return cell
            } else if indexPath.row == 2 {
                // If the section is any other value, it dequeues and configures a cell of type `SleepHoursCollectionViewCell` using the "sleephoursCell" reuse identifier.
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sleephoursCell", for: indexPath) as! SleepHoursCollectionViewCell
                let image = UIImage(named: "pieChart.png")
                cell.imageView.image = image
                return cell
            } else {
                // If the section is any other value, it dequeues and configures a cell of type `BPMCollectionViewCell` using the "bpmCell" reuse identifier.
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bpmCell", for: indexPath) as! BPMCollectionViewCell
                cell.dataLabel.text = "71"
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    }
    
}
