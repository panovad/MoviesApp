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
    
    //Helpers
    public var movie: Movie!
    var genres = [Genre]()

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
        let decoder = JSONDecoder()
        let path = Constants.Endpoints.movieGenres
        
        if Utilities.sharedInstance.hasInternetConnection() {
            APIManager.sharedInstance.makeRequest(path: path) { success, response, statusCode in
                if success {
                    if statusCode == 200 {
                        if let data = response {
                            do {
                                let decoded = try decoder.decode(Genres.self, from: data)
                                if let genres = decoded.genres {
                                    self.genres = genres
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
        
    }
}
