//
//  ChartCollectionViewCell.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 03/06/2023.
//

import UIKit
import Charts

/// A collection view cell to show charts created.
class ChartCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var iconImageview: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}
