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
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
        
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
            if self.pagination.total_pages ?? 0 > self.currentPage {
                self.currentPage += 1
                self.getPopularMovies()
                print("CURRENT PAGE: ", self.currentPage)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsVc = MovieDetailsViewController()
        movieDetailsVc.movie = self.popularMovies[indexPath.row]
        movieDetailsVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailsVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.frame.self.width / 2) - 20
        if indexPath.row % 3 == 0 {
            return CGSize(width: width, height: self.view.frame.size.height / 2.8)
        } else if indexPath.row % 4 == 0 {
            return CGSize(width: width, height: self.view.frame.size.height / 3.1)
        } else if indexPath.row % 2 == 0 {
            return CGSize(width: width, height: self.view.frame.size.height / 2.9)
        } else {
            return CGSize(width: width, height: self.view.frame.size.height / 3.3)
        }
    }
}

//MARK: - Get Popular Movies API Request
extension MoviesViewController {
    func getPopularMovies() {
        let decoder = JSONDecoder()
        
        //adding 'currentPage' at the end in order to be able to have pagination
        let path = Constants.Endpoints.popularMovies + "\(currentPage)"
        
        if Utilities.sharedInstance.hasInternetConnection() {
            APIManager.sharedInstance.makeRequest(path: path) { success, response, statusCode in
                if success {
                    if statusCode == 200 {
                        if let data = response {
                            do {
                                let decoded = try decoder.decode(PaginationMovies.self, from: data)
                                self.pagination = decoded
                                if let movies = decoded.results {
                                    self.popularMovies += movies
                                    
                                    DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                    }
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            Utilities.sharedInstance.createOKAlert(title: "Error loading data!", viewController: self)
                        }
                    } else {
                        Utilities.sharedInstance.createOKAlert(title: "There was a problem loading this request. Please try again later.", viewController: self)
                    }
                } else {
                    Utilities.sharedInstance.createOKAlert(title: "There was a problem loading this request. Please try again later.", viewController: self)
                }
            }
        } else {
            Utilities.sharedInstance.createOKAlert(title: "Please check your internet connection and try again.", viewController: self)
        }
    }
}
