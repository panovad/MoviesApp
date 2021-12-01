//
//  MoviesViewController.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import UIKit

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
        setupViews()
        setupConstraints()
        getPopularMovies()
    }
    
    //MARK: - Setup Views
    func setupViews() {
        self.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
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
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
    }
}

//MARK: - UICollectionView Delegate & Data Source
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.setupCell(movie: self.popularMovies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width / 2) - 20, height: self.view.frame.size.height / 3)
    }
}

//MARK: - Get Popular Movies API
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
                                if let movies = decoded.results {
                                    self.popularMovies = movies
                                }
                                
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
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
