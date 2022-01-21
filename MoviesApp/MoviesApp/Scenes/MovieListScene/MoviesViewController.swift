//
//  MoviesViewController.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import UIKit
import CollectionViewWaterfallLayout

class MoviesViewController: UIViewController {
    
    //UI Elements
    var pageControl: UIPageControl!
    var collectionView: UICollectionView!
        
    //Helpers
    var currentPage = 1
    var popularMovies = [Movie]()
    var pagination = PaginationMovies()
    var favoriteMovies = [Movie]()

    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        Utilities.sharedInstance.setupNavigationBar(controller: self, title: "Popular Movies")
        setupViews()
        setupConstraints()
        getPopularMovies()
    }
    
    //MARK: - Setup Views
    func setupViews() {
        self.view.backgroundColor = .white
        
        let layout = CollectionViewWaterfallLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
    }
    
    //MARK: - Setup Constraints
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - UICollectionView Delegate & Data Source
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.setupCell(movie: self.popularMovies[indexPath.row])
        
        if indexPath.row == self.popularMovies.count - 1 {
            if self.pagination.totalPages ?? 0 > self.currentPage {
                self.currentPage += 1
                self.getPopularMovies()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsVc = MovieDetailsViewController()
        movieDetailsVc.movie = self.popularMovies[indexPath.row]
        //Hide the tabBar on the screen that follows
        movieDetailsVc.hidesBottomBarWhenPushed = true
        //check if the movie we selected is favorite so we can handle the appearance of favoriteBarButtonItem in MovieDetailsVC
        movieDetailsVc.movieIsFavorite = self.checkIfMovieIsFavorite(movieId: self.popularMovies[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(movieDetailsVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.frame.self.width / 2) - 20
        //Setting different heights for diffferent rows, just for a more fun appearance
        if indexPath.row % 3 == 0 {
            return CGSize(width: width, height: self.view.frame.size.height / 2.2)
        } else if indexPath.row % 4 == 0 {
            return CGSize(width: width, height: self.view.frame.size.height / 2.3)
        } else if indexPath.row % 2 == 0 {
            return CGSize(width: width, height: self.view.frame.size.height / 2.4)
        } else {
            return CGSize(width: width, height: self.view.frame.size.height / 2.6)
        }
    }
}

//MARK: - Get Popular Movies API Request
extension MoviesViewController {
    func getPopularMovies() {
        if NetworkManager.sharedInstance.hasInternetConnection() {
            NetworkManager.sharedInstance.getPopularMovies(page: currentPage) { paginationMovies, error in
                if let movies = paginationMovies?.results, let pagination = paginationMovies {
                    self.popularMovies += movies
                    self.pagination = pagination
                    DispatchQueue.main.async {
                        self.collectionView.reloadSections(IndexSet(integer: 0))
                    }
                } else {
                    Utilities.sharedInstance.createOKAlert(title: error?.localizedDescription ?? "An error has occured. Please try again later.", viewController: self)
                }
            }
        } else {
            Utilities.sharedInstance.createOKAlert(title: "Please check your internet connection and try again.", viewController: self)
        }
    }
}

//MARK: - Helper Methods
extension MoviesViewController {
    //Check if a movie is favorite by id
    func checkIfMovieIsFavorite(movieId: Int) -> Bool {
        //Get all the favorite movies that we keep locally
        self.favoriteMovies = UserDefaultsManager.sharedInstance.getFavoriteMovies() ?? [Movie]()
        
        var isFavorite: Bool = false
        //Iterate through the movie list and look if there is a match in the list for the current movieId. If you find a match, break out of the for-loop; else keep going until you check the last element
        for movie in favoriteMovies {
            if movie.id == movieId {
                isFavorite = true
                break
            } 
        }
        return isFavorite
    }
}
