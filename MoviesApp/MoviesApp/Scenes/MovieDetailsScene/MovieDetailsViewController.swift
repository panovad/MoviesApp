//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Danche Panova on 2.12.21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    //UI Elements
    var tableView: UITableView!
    var favoriteBarButtonItem: UIBarButtonItem!
    
    //Helpers
    public var movieIsFavorite: Bool = false
    public var movie: Movie!
    var genres = [Genre]()
    var numberOfTaps: Int = 0

    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.sharedInstance.setupNavigationBar(controller: self, title: "Movie Details")
        setupViews()
        setupConstraints()
        getMovieGenres()
    }
    
    //MARK: - Setup Views
    func setupViews() {
        
        self.view.backgroundColor = .white
        
        favoriteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(buttonAction(sender:)))
        favoriteBarButtonItem.tintColor = .systemRed
        self.navigationItem.rightBarButtonItem = favoriteBarButtonItem
        
        if self.movieIsFavorite {
            favoriteBarButtonItem.image = UIImage(systemName: "heart.fill")
        }
        
        tableView = UITableView()
        tableView.register(MovieDetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        self.view.addSubview(tableView)
        
    }
    
    //MARK: - Setup Constraints
    func setupConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - UITableView Delegate & DataSource
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieDetailsTableViewCell
        cell.setupCell(movie: self.movie)
        cell.findCurrentMovieGenres(genres: self.genres)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Get Movie Genres API Request
extension MovieDetailsViewController {
    func getMovieGenres() {
        //Check if the user has Internet Connection
        if NetworkManager.sharedInstance.hasInternetConnection() {
            NetworkManager.sharedInstance.getMovieGenres { genres, error in
                if let genres = genres?.genres {
                    self.genres = genres
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else if let errorDesc = error?.localizedDescription {
                    Utilities.sharedInstance.createOKAlert(title: errorDesc, viewController: self)
                } else {
                    Utilities.sharedInstance.createOKAlert(title: error?.localizedDescription ?? "An error has occured. Please try again later.", viewController: self)
                }
            }
        } else {
            Utilities.sharedInstance.createOKAlert(title: "Please check your internet connection and try again.", viewController: self)
        }
    }
}

//MARK: - UIBarButtonItem Action
extension MovieDetailsViewController {
    @objc func buttonAction(sender: UIBarButtonItem) {
        //Increment the number of times 'favorite button' has been tapped
        if !movieIsFavorite {
            //If the movie has not been set to 'favorite' so far, set it to favorite
            self.favoriteBarButtonItem.image = UIImage(systemName: "heart.fill")
            self.movieIsFavorite = true
        } else {
            //If the movie has been set to 'favorite' so far, set it to not favorite
            self.favoriteBarButtonItem.image = UIImage(systemName: "heart")
            self.movieIsFavorite = false
            
        }
        //Update the 'favorite movies' list
        self.updateFavoriteMovieList(favorite: self.movieIsFavorite)
    }
    
    func updateFavoriteMovieList(favorite: Bool) {
        //Get all the favorite movies
        var favoriteMovies = UserDefaultsManager.sharedInstance.getFavoriteMovies() ?? [Movie]()
        //If a movie has been favored, we will add it to the list -- otherwise, we remove it from the list of favorite movies
        if favorite {
            favoriteMovies.append(self.movie)
        } else {
            favoriteMovies.removeAll(where: { movie in
                movie.id == self.movie.id
            })
        }
        //Save the new list of favorite movies
        UserDefaultsManager.sharedInstance.saveFavoriteMovies(movies: favoriteMovies)
        //Post a notification that 'FavoriteMoviesVC' listens for
        NotificationCenter.default.post(name: Notification.Name("favoriteMoviesListUpdated"), object: nil)
    }
}
