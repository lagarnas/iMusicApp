//
//  MainTabBarController.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    
    viewControllers = [
      generateViewController(rootViewController: searchVC, image: UIImage(systemName: "magnifyingglass")!, title: "Search"),
      generateViewController(rootViewController: LibraryViewController(), image: UIImage(systemName: "heart.fill")!, title: "Library")
    ]
  }
  
  private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
    let navigationVC = UINavigationController(rootViewController: rootViewController)
    navigationVC.tabBarItem.image = image
    navigationVC.tabBarItem.title = title
    rootViewController.navigationItem.title = title
    navigationVC.navigationBar.prefersLargeTitles = true
    return navigationVC
  }
  
}
