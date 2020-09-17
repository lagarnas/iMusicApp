//
//  MainTabBarController.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
  
  private var minimizedTopAnchorConstraint: NSLayoutConstraint!
  private var maximizedTopAnchorConstraint: NSLayoutConstraint!
  private var bottomAnchorConstraint: NSLayoutConstraint!
  
  let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
  let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
    
    setupTrackDetailView()
    
    searchVC.tabBarDelegate = self
    
    var library = Library()
    library.tabBarDelegate = self
    let hostVC = UIHostingController(rootView: library)
    hostVC.tabBarItem.image = #imageLiteral(resourceName: "library")
    hostVC.tabBarItem.title = "Library"
    
    viewControllers = [
      hostVC,
      generateViewController(rootViewController: searchVC, image: UIImage(systemName: "magnifyingglass")!, title: "Search")
//      generateViewController(rootViewController: hostVC, image: UIImage(systemName: "heart.fill")!, title: "Library")
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
  
  private func setupTrackDetailView() {
    
    trackDetailView.tabBarDelegate = self
    trackDetailView.delegate = searchVC
    view.insertSubview(trackDetailView, belowSubview: tabBar)
    
    //use autoLayout
    trackDetailView.translatesAutoresizingMaskIntoConstraints = false
    maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
    minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
    bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
    bottomAnchorConstraint.isActive = true
    
    maximizedTopAnchorConstraint.isActive = true
    
    trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    
  }
}

extension MainTabBarController: MainTabBarControllerDelegate {
  
  func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
    minimizedTopAnchorConstraint.isActive = false
    maximizedTopAnchorConstraint.isActive = true
    maximizedTopAnchorConstraint.constant = 0
    bottomAnchorConstraint.constant = 0
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.view.layoutIfNeeded()
                    self.tabBar.alpha = 0
                    self.trackDetailView.miniTrackView.alpha = 0
                    self.trackDetailView.maximizedStackView.alpha = 1
    },
                   completion: nil)
    
    guard let viewModel = viewModel else { return }
    self.trackDetailView.configure(viewModel: viewModel)
  }
  
  func minimizeTrackDetailController() {
    maximizedTopAnchorConstraint.isActive = false
    bottomAnchorConstraint.constant = view.frame.height
    minimizedTopAnchorConstraint.isActive = true
  
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.view.layoutIfNeeded()
                    self.tabBar.alpha = 1
                    self.trackDetailView.miniTrackView.alpha = 1
                    self.trackDetailView.maximizedStackView.alpha = 0
    },
                   completion: nil)
  }
  
  
}
