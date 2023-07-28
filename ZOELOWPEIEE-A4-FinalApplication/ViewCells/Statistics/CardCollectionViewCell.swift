//
//  CardCollectionViewCell.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 03/06/2023.
//

import UIKit

// A collection view cell that represents a card item.
class CardCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
}
