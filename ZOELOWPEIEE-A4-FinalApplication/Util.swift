//
//  Util.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 03/06/2023.
//

import UIKit
import Charts

/// A custom UIView subclass that represents a card view with customizable properties.
/// It is designed to be used in Interface Builder (IB) and provides live rendering of its properties.
@IBDesignable
class CardView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}

/// A custom subclass of CardView that adds gradient background functionality.
@IBDesignable
class GradientView: CardView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    /// This method sets up a gradient background for the view using the provided `firstColor` and `secondColor` properties.
    /// The gradient can be set to either horizontal or vertical orientation based on the `isHorizontal` flag.
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
}

/// A custom subclass of UIImageView that adds rounded corners and shadow properties.
@IBDesignable
class CardImage: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    @IBInspectable var rounded: Bool = false
    
    /// This method is called whenever the view's layout needs to be updated.
    /// It adjusts the corner radius of the view's layer based on the `rounded` property.
    override func layoutSubviews() {
        if self.rounded {
            // If `rounded` is true, the corner radius is set to make the view appear as a circle.
            self.layer.cornerRadius = self.frame.height / 2
        } else {
            // Otherwise, it is set to the `cornerRadius` property value.
            self.layer.cornerRadius = cornerRadius
        }
    }
}

/// An enumeration representing the position of a line view.
enum LINE_POSITION {
    case top
    case bottom
}


extension UIView {
    /// This method adds a horizontal line view to the receiver view with the specified position, color, and width.
    /// - Parameters:
    ///   - position: The position of the line view.
    ///   - color: The color of the line view.
    ///   - width: The width of the line view.
    func addLine(position: LINE_POSITION = .bottom, color: UIColor = UIColor.lightGray, width: Double = 1.0) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}

extension UINavigationController {
    /// Sets the navigation bar of the view controller to transparent.
    func setTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}


