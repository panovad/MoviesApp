//
//  FavoriteMovieTableViewCell.swift
//  MoviesApp
//
//  Created by Danche Panova on 3.12.21.
//

import UIKit

protocol FavoriteMovieTableViewCellDelegate {
    func favoriteButtonTapped(row: Int)
}

class FavoriteMovieTableViewCell: UITableViewCell {
    
    //UI Elements
    var mainImageView: UIImageView!
    var titleLabel: UILabel!
    var genresLabel: UILabel!
    var overviewLabel: UILabel!
    var favoriteButton: UIButton!
    
    //Delegate
    var delegate: FavoriteMovieTableViewCellDelegate!

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Views
    func setupViews() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        
        mainImageView = Utilities.sharedInstance.createImageViewWith(imageName: "", contentMode: .scaleAspectFill)
        
        titleLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 20, weight: .bold), textColor: .black, backgroundColor: .clear)
        titleLabel.numberOfLines = 5
        
        favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.tintColor = .systemRed
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(sender:)), for: .touchUpInside)
        
        genresLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 14), textColor: .lightGray, backgroundColor: .clear)
        genresLabel.numberOfLines = 3
        
        overviewLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 16), textColor: .darkGray, backgroundColor: .clear)
        overviewLabel.numberOfLines = 4
        
        self.contentView.addSubview(mainImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(favoriteButton)
        self.contentView.addSubview(genresLabel)
        self.contentView.addSubview(overviewLabel)
    }
    
    //MARK: - Setup Constraints
    func setupConstraints() {
        self.mainImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.contentView)
            make.height.equalTo(UIScreen.main.bounds.height * 0.3)
        }
        
        self.favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(self.mainImageView.snp.bottom).offset(20)
            make.width.height.equalTo(30)
            make.right.equalTo(self.contentView).offset(-10)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mainImageView.snp.bottom).offset(20)
            make.left.equalTo(self.contentView).inset(15)
            make.right.equalTo(self.favoriteButton.snp.left).offset(-10)
        }
        
        self.genresLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(self.titleLabel)
        }
        
        self.overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(self.genresLabel.snp.bottom).offset(15)
            make.left.right.equalTo(self.titleLabel)
            make.bottom.equalTo(self.contentView).offset(-20)
        }
    }
    
    //MARK: - Setup Cell
    func setupCell(movie: Movie) {
        let imgPath = "https://image.tmdb.org/t/p/w500" + (movie.backdrop_path ?? "")
        APIManager.sharedInstance.downloadImage(from: URL(string: imgPath)!, imageView: self.mainImageView)
        
        self.titleLabel.text = movie.title ?? "Unknown"
        self.overviewLabel.text = movie.overview ?? "/"
    }
}

//MARK: - UIButton Action
extension FavoriteMovieTableViewCell {
    @objc func favoriteButtonTapped(sender: UIButton) {
        self.delegate.favoriteButtonTapped(row: sender.tag)
    }
}
