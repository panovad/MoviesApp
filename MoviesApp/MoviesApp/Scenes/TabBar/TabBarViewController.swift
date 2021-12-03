//
//  TabBarViewController.swift
//  MoviesApp
//
//  Created by Danche Panova on 1.12.21.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var moviesVc: UINavigationController!
    var favoritesVc: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: - Setup TabBar
    func setupTabBar() {
        self.tabBar.backgroundColor = .secondarySystemBackground
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .gray
        self.selectedIndex = 0
        
        self.moviesVc = UINavigationController(rootViewController: MoviesViewController())
        self.moviesVc.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "video"), selectedImage: UIImage(systemName: "video.fill"))
        
        self.favoritesVc = UINavigationController(rootViewController: FavoriteMoviesViewController())
        self.favoritesVc.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        self.viewControllers = [moviesVc, favoritesVc]
    }
}
