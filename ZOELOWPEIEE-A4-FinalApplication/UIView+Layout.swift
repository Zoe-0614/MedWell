//
//  UIView+Layout.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 17/05/2023.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding:
                UIEdgeInsets = .zero, size: CGSize = .zero) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }

        layoutMargins = padding
    }
}
