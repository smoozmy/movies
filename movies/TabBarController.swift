//
//  ViewController.swift
//  movies
//
//  Created by Александр Крапивин on 20.07.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
            super.viewDidLoad()
            
            let random = RandomViewController()
            let news = NewsViewController()
            
            random.tabBarItem = UITabBarItem(
                title: nil,
                image: UIImage(systemName: "magnifyingglass.circle"),
                selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
            )
            random.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
            news.tabBarItem = UITabBarItem(
                title: nil,
                image: UIImage(systemName: "newspaper.circle"),
                selectedImage: UIImage(systemName: "newspaper.circle.fill")
            )
            news.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
            self.viewControllers = [
                random,
                news
            ]
            configureTabBarAppearance()
        }
        
        private func configureTabBarAppearance() {
            let tabBar = self.tabBar
            tabBar.barTintColor = .black
            tabBar.unselectedItemTintColor = .white
            tabBar.tintColor = .white
            tabBar.isTranslucent = false
            
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
            
            if #available(iOS 13.0, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .black
                
                
                appearance.shadowColor = .black
                
                tabBar.standardAppearance = appearance
                if #available(iOS 15.0, *) {
                    tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                }
            }
        }
}

