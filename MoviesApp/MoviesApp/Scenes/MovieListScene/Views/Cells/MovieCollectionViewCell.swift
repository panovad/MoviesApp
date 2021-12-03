//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    //UI Elements
    var mainImageView: UIImageView!
    var titleLabel: UILabel!
    var overviewLabel: UILabel!
    var ratingView: RatingView!
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
    
    //MARK: - Setup Views
    func setupViews() {
        self.contentView.backgroundColor = .clear
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.borderWidth = 0.5
        
        mainImageView = Utilities.sharedInstance.createImageViewWith(imageName: "", contentMode: .scaleAspectFill)
        
        titleLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 20, weight: .bold), textColor: .white, backgroundColor: UIColor.darkGray.withAlphaComponent(0.3))
        
        overviewLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 15), textColor: .white, backgroundColor: UIColor.darkGray.withAlphaComponent(0.7))
        overviewLabel.numberOfLines = 4
        
        ratingView = RatingView(frame: .zero, rating: 0)
        ratingView.layer.cornerRadius = 5
        
        //Some changes for smaller devices
        if Utilities.sharedInstance.iphoneType(type: .iphone5) {
            titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
            overviewLabel.font = .systemFont(ofSize: 13)
            overviewLabel.numberOfLines = 3
            titleLabel.numberOfLines = 4
        }
        
        self.contentView.addSubview(mainImageView)
        self.mainImageView.addSubview(titleLabel)
        self.mainImageView.addSubview(overviewLabel)
        self.mainImageView.addSubview(ratingView)
    }
    
    //MARK: - Setup Constraints
    func setupConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.mainImageView).inset(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.overviewLabel.snp.top).offset(-15)
            make.left.right.equalTo(self.overviewLabel)
        }
        
        ratingView.snp.makeConstraints { make in
            //If the device has the dimensions of an iPhone 5 or smaller, we set different sizes
            if Utilities.sharedInstance.iphoneType(type: .iphone5) {
                make.width.equalTo(40)
                make.height.equalTo(25)
            } else {
                make.width.equalTo(50)
                make.height.equalTo(30)
            }
            make.top.right.equalTo(self.mainImageView).inset(5)
        }
    }
    
    //MARK: - Setup Cell
    func setupCell(movie: Movie) {
        let imgPath = "https://image.tmdb.org/t/p/w500" + (movie.poster_path ?? "")
        APIManager.sharedInstance.downloadImage(from: URL(string: imgPath)!, imageView: self.mainImageView)
        
        self.overviewLabel.text = movie.overview
        self.titleLabel.text = movie.title
        self.ratingView.ratingLabel.text = "\(movie.vote_average ?? 0.0)"
    }
}
