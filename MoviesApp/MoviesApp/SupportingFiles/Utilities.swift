//
//  Utilities.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation
import UIKit

class Utilities {
    
    static let sharedInstance = Utilities()
    
    //MARK: - Alerts
    func createOKAlert(title: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //Check if device has Internet Connection
    func hasInternetConnection() -> Bool {
        return Reachability.sharedInstance.isInternetAvailable()
    }
    
    //Convert Hex String to UIColor
    func colorFromHexCode(hex: String) -> UIColor {
        let r, g, b, a: CGFloat
        
        var hexColor = hex
        
        if hex.hasPrefix("#") {
            hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexColor = hexColor.replacingOccurrences(of: "#", with: "")
        }
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x000000ff) / 255
                
                return UIColor(red: r, green: g, blue: b, alpha: a)
            }
        } else if (hexColor.count == 6) {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                b = CGFloat(hexNumber & 0x0000FF) / 255.0
                
                return UIColor(red: r, green: g, blue: b, alpha: 1.0)
            }
            
        }
        return .clear
    }
    
    //MARK: - UIElements Creation -- Helper methods
    //UILabel Creation
    func createLabelWith(text: String, txtAlignment: NSTextAlignment, font: UIFont, textColor: UIColor, backgroundColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.textAlignment = txtAlignment
        label.numberOfLines = 0
        
        return label
    }
    
    //UIImageView Creation
    func createImageViewWith(imageName: String?, contentMode: UIImageView.ContentMode?) -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        
        if let tmpImageName = imageName {
            imageView.image = UIImage(named: tmpImageName)
        }
        
        if let tmpContentMode = contentMode {
            imageView.contentMode = tmpContentMode
        }
        
        return imageView
    }
}
