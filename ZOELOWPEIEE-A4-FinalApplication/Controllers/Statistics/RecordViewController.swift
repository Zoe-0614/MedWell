//
//  RecordViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 03/06/2023.
//


import UIKit
import Charts

/// The view controller for recording data and displaying charts of the statistics of the user.
class RecordViewController: UIViewController {
    
    //MARK: - Properties
    var barChartView: BarChartView!
    var values: [Double] = []
    var labelTitle: String = ""
    var labelDescription: String = ""
    var icon: UIImage = UIImage()
    var recordsLabel: [String] = []
    var recordsValue: [Double] = []
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - View Transition
    
    /// This method notifies the view controller that its view is about to transition to a new size.
    /// - Parameters:
    ///   - size: The new size for the container’s view.
    ///   - coordinator: The transition coordinator object managing the size change.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    //MARK: - Chart Creation
    
    /// The method creates a bar chart with the provided data points and values.
    /// - Parameters:
    ///   - barChartView: The BarChartView instance to configure.
    ///   - dataPoints: An array of strings representing the x-axis labels.
    ///   - values: An array of double values representing the y-axis values.
    func create(barChartView: BarChartView, dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
        chartDataSet.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension RecordViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// This method asks the data source for the number of sections in the collection view.
    /// - Parameter collectionView: The collection view requesting this information.
    /// - Returns: The number of sections in collectionView.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// This method asks the data source for the number of items in the specified section.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: An index number identifying a section in collectionView.
    /// - Returns: The number of items in section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sections = 1
        if section == 1 {
            sections = recordsLabel.count
        }
        
        return sections
    }
    
    /// This method asks the data source for the cell that corresponds to the specified item in the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.
    /// - Returns: A configured cell object. You must not return nil from this method.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCell", for: indexPath) as! ChartCollectionViewCell
            self.create(barChartView: cell.chartView, dataPoints: recordsLabel, values: recordsValue)
            cell.titleLabel.text = labelTitle
            cell.descriptionLabel.text = labelDescription
            cell.iconImageview.image = icon
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCollectionViewCell
        cell.titleLabel.text = recordsLabel[indexPath.row]
        cell.descriptionLabel.text = String(recordsValue[indexPath.row])
        return cell
        
    }
    
    /// This method asks the delegate for the size of the specified item’s cell.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - indexPath: The index path of the item.
    /// - Returns: The width and height of the specified item. Both values must be greater than 0.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        let device = UIDevice.current
        
        if indexPath.section == 0 {
            return CGSize(width: width * 0.95, height: height * 0.3)
        }
        return CGSize(width: Double(width) * 0.95, height: 80.0)
    }
    
}
