//
//  MovieDetailsTableViewCell.swift
//  MoviesApp
//
//  Created by Danche Panova on 2.12.21.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    
    //UI Elements
    var mainImageView: UIImageView!
    var titleLabel: UILabel!
    var overviewLabel: UILabel!
    var ratingView: RatingView!
    var genresLabel: UILabel!
    var calendarImageView: UIImageView!
    var releaseDateLabel: UILabel!
    
    //Helpers
    var movie: Movie!
    
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
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
        mainImageView = Utilities.sharedInstance.createImageViewWith(imageName: "", contentMode: .scaleAspectFill)
        
        titleLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 25, weight: .bold), textColor: .black, backgroundColor: .clear)
        
        overviewLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 16), textColor: .darkGray, backgroundColor: .clear)
        
        ratingView = RatingView(frame: .zero, rating: 0)
        ratingView.layer.cornerRadius = 7
        
        genresLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .center, font: .italicSystemFont(ofSize: 16), textColor: .systemGray, backgroundColor: .clear)
        genresLabel.numberOfLines = 3
        
        calendarImageView = UIImageView(image: UIImage(systemName: "calendar")?.withTintColor(.systemGray))
        
        releaseDateLabel = Utilities.sharedInstance.createLabelWith(text: "", txtAlignment: .left, font: .systemFont(ofSize: 14, weight: .medium), textColor: .darkGray, backgroundColor: .clear)
        
        self.contentView.addSubview(mainImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(overviewLabel)
        self.contentView.addSubview(ratingView)
        self.contentView.addSubview(genresLabel)
        self.contentView.addSubview(calendarImageView)
        self.contentView.addSubview(releaseDateLabel)
    }
    
    //MARK: - Setup Constraints
    func setupConstraints() {
        self.mainImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.contentView)
            if Utilities.sharedInstance.iphoneType(type: .iphone5) {
                make.height.equalTo(UIScreen.main.bounds.height * 0.4)
            } else {
                make.height.equalTo(UIScreen.main.bounds.height * 0.3)
            }
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.contentView).inset(20)
            make.top.equalTo(self.mainImageView.snp.bottom).offset(20)
        }
        
        self.ratingView.snp.makeConstraints { make in
            make.top.right.equalTo(self.mainImageView).inset(20)
            if Utilities.sharedInstance.iphoneType(type: .iphone5) {
                make.width.equalTo(60)
                make.height.equalTo(30)
            } else {
                make.width.equalTo(75)
                make.height.equalTo(40)
            }
        }
        
        self.genresLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(self.titleLabel)
        }
        
        self.calendarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.genresLabel.snp.bottom).offset(15)
            make.left.equalTo(self.genresLabel)
            make.width.height.equalTo(30)
        }
        
        self.releaseDateLabel.snp.makeConstraints { make in
            make.left.equalTo(self.calendarImageView.snp.right).offset(15)
            make.centerY.equalTo(self.calendarImageView)
            make.height.equalTo(20)
        }
        
        self.overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(self.releaseDateLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.titleLabel)
            make.bottom.equalTo(self.contentView).offset(-20)
        }
    }
    
    //MARK: - Setup Cell
    func setupCell(movie: Movie) {
        self.movie = movie
        
        let imgPath = "https://image.tmdb.org/t/p/w500" + (movie.backdrop_path ?? "")
        APIManager.sharedInstance.downloadImage(from: URL(string: imgPath)!, imageView: self.mainImageView)
        
        self.overviewLabel.text = movie.overview
        self.titleLabel.text = movie.title
        self.ratingView.ratingLabel.text = "\(movie.vote_average ?? 0.0)"
        
        //If there is releaseDate available, format the string to look a bit different; else, show "unknown" release date
        if let releaseDate = movie.release_date {
            let dateStringFormatted = Utilities.sharedInstance.dateConvertor(fromFormat: "yyyy-MM-dd", toFormat: "MMM d, yyyy", dateString: releaseDate)
            self.releaseDateLabel.text = "Release date: " + dateStringFormatted
        } else {
            self.releaseDateLabel.text = "Unknown"
        }
    }
    
    //MARK: - Find Movie Genres
    //Used to show the current movie's genres -- because we get the genre list separately and only get genre id's from the movie details
    func findCurrentMovieGenres(genres: [Genre]) {
        var currentMovieGenres = [Genre]()
        //Iterate through all the genres available and the current movie's genres, then  look for a match between them
        for genre in genres {
            for currentGenre in self.movie.genre_ids ?? [Int]() {
                if genre.id == currentGenre {
                    currentMovieGenres.append(genre)
                }
            }
        }
        //Update the UILabel text 
        self.setupGenreLabel(genres: currentMovieGenres)
    }
    
    //Add the genres to the UILabel text
    func setupGenreLabel(genres: [Genre]) {
        var labelText = ""
        for genre in genres {
            labelText = labelText + (genre.name ?? "") + ", "
        }
        self.genresLabel.text = String(labelText.dropLast(2)) //delete the last ","
    }
}
