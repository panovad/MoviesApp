//
//  RatingView.swift
//  MoviesApp
//
//  Created by Danche Panova on 1.12.21.
//

import UIKit
import SnapKit

class RatingView: UIView {
    
    //UI Elements
    var ratingLabel: UILabel!
    
    //Helpers
    var rating: Int!

    //MARK: - Init
    init(frame: CGRect, rating: Int) {
        super.init(frame: frame)
        self.rating = rating
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Views
    func setupViews() {
        self.backgroundColor = Utilities.sharedInstance.colorFromHexCode(hex: "#3d8072")
        
        ratingLabel = Utilities.sharedInstance.createLabelWith(text: "\(rating ?? 0)", txtAlignment: .center, font: .systemFont(ofSize: 18, weight: .bold), textColor: .white, backgroundColor: .clear)
        
        if Utilities.sharedInstance.iphoneType(type: .iphone5) {
            ratingLabel.font = .systemFont(ofSize: 13, weight: .bold)
        }
        
        self.addSubview(ratingLabel)
        
        ratingLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
