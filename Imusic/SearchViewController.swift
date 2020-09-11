//
//  SearchViewController.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



class SearchMusicViewController: UITableViewController {
  
  var networkService = NetworkService()
  
  private var timer: Timer?
  
  let searchController = UISearchController(searchResultsController: nil)
  
  var tracks = [Track]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupSearchBar()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  //SearchBar
  
  private func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.delegate = self
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tracks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let track = tracks[indexPath.row]
    cell.textLabel?.text = track.trackName + " " + track.artistName
    cell.imageView?.image = #imageLiteral(resourceName: "3")
    return cell
  }
}

extension SearchMusicViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      
      self.networkService.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
        guard let self = self else { return }
        self.tracks = searchResults?.results ?? []
        self.tableView.reloadData()
      }
    })
  }
}
