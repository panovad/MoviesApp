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
    
    //MARK: - Convert date string to another date string format
    func dateConvertor(fromFormat: String, toFormat: String, dateString: String) -> String {
        
        var convertedDate = ""
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = fromFormat
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = toFormat
        
        if let date = dateFormatterGet.date(from: dateString) {
            convertedDate = dateFormatterPrint.string(from: date)
        } else {
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatterGet.date(from: dateString) {
                convertedDate = dateFormatterPrint.string(from: date)
            } else {
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let date = dateFormatterGet.date(from: dateString) {
                    convertedDate = dateFormatterPrint.string(from: date)
                }
            }
        }
        return convertedDate
    }
    
    //MARK: - Setup Navigation Bar
    func setupNavigationBar(controller: UIViewController, title: String) {
        
        controller.navigationController?.navigationBar.prefersLargeTitles = true
        controller.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        controller.navigationItem.largeTitleDisplayMode = .always

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .secondarySystemBackground
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 34)]
        
        controller.navigationController?.navigationBar.standardAppearance = navBarAppearance
        controller.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        controller.navigationItem.title = title
        controller.navigationController?.navigationBar.setNeedsDisplay()
    }
    
    //MARK: - CHECK IPHONE TYPE
    func iphoneType(type: iPhoneType) -> Bool {
        let bounds = UIScreen.main.bounds
        let maxLength = max(bounds.size.height, bounds.size.width)
        switch type {
        case .iPhone5:
            return (maxLength <= 568)
        case .Other:
            return (maxLength > 568) && (maxLength <= 667)
        case .iPhonePlus:
            return (maxLength > 667) && (maxLength <= 736)
        case .iPhoneXorXs:
            return (maxLength > 736) && (maxLength <= 895)
        case .iPhone11orBigger:
            return (maxLength > 895)
        }
    }
}

enum iPhoneType {
    case iPhone11orBigger
    case iPhoneXorXs
    case iPhonePlus
    case iPhone5
    case Other
}
