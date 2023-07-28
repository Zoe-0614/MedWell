//
//  BPMCollectionViewCell.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Soo yew Lim on 09/06/2023.
//

import UIKit

/// A collection view cell used to display BPM (Beats Per Minute) information
class BPMCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    
    /// The label for displaying analysis data about the BPM information
    @IBOutlet weak var analysisLabel: UILabel!
    /// The label for displaying the data value of the BPM information
    @IBOutlet weak var dataLabel: UILabel!
}
