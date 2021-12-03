//
//  FavoriteMoviesViewController.swift
//  MoviesApp
//
//  Created by Danche Panova on 3.12.21.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    
    //UI Elements
    var tableView: UITableView!
    var noDataLabel: UILabel!
    
    //Helpers
    var favoriteMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMovieList), name: NSNotification.Name("favoriteMoviesListUpdated"), object: nil)
        Utilities.sharedInstance.setupNavigationBar(controller: self, title: "Favorite Movies")
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Views
    func setupViews() {
        self.view.backgroundColor = .white
        
        favoriteMovies = UserDefaultsManager.sharedInstance.getFavoriteMovies() ?? [Movie]()
        
        tableView = UITableView()
        tableView.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        noDataLabel = Utilities.sharedInstance.createLabelWith(text: "No favorite movies", txtAlignment: .center, font: .systemFont(ofSize: 15), textColor: .darkGray, backgroundColor: .clear)
        //If there are not any favorite movies, show 'No favorite movies'
        self.handleShowingNoDataLabel()
        
        self.view.addSubview(tableView)
        self.view.addSubview(noDataLabel)
    }
    
    //MARK: - Setup Constraints
    func setupConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        
        self.noDataLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.view).inset(10)
            make.centerY.equalTo(self.view)
        }
    }
}

//MARK: - UITableView Delegate & Data Source
extension FavoriteMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavoriteMovieTableViewCell
        cell.setupCell(movie: self.favoriteMovies[indexPath.row])
        cell.favoriteButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVc = MovieDetailsViewController()
        movieDetailsVc.movie = self.favoriteMovies[indexPath.row]
        movieDetailsVc.hidesBottomBarWhenPushed = true
        //This will be true for every item of the Movies list because they all are favorites here
        movieDetailsVc.movieIsFavorite = true
        self.navigationController?.pushViewController(movieDetailsVc, animated: true)
    }
}

//MARK: - FavoriteMovieTableViewCell Delegate
extension FavoriteMoviesViewController: FavoriteMovieTableViewCellDelegate {
    func favoriteButtonTapped(row: Int) {
        //Begin tableView updates
        self.tableView.beginUpdates()
        //Delete the row from the tableView where the user tapped on 'favoriteButton' (which was full)
        self.tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        //Remove the object from the array
        self.favoriteMovies.remove(at: row)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        //End updates
        self.tableView.endUpdates()
        //Check if we should show 'noDataLabel'
        self.handleShowingNoDataLabel()
        //Save the new array locally
        UserDefaultsManager.sharedInstance.saveFavoriteMovies(movies: self.favoriteMovies)
    }
}

//MARK: - Refresh Movie List
extension FavoriteMoviesViewController {
    //Refresh the movie list if the VC has already been loaded before
    @objc func refreshMovieList() {
        //Get all the favorite movies
        self.favoriteMovies = UserDefaultsManager.sharedInstance.getFavoriteMovies() ?? [Movie]()
        //Call this method to check if we should show or hide the 'noDataLabel'
        self.handleShowingNoDataLabel()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Helper method for showing/hiding the 'noDataLabel'
    func handleShowingNoDataLabel() {
        //If there are no favorite movies, show the label -- otherwise, hide the label
        if self.favoriteMovies.count == 0 {
            self.noDataLabel.isHidden = false
        } else {
            self.noDataLabel.isHidden = true
        }
    }
}
