//
//  SearchViewController.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright (c) 2020 lagarnas. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
  
  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
  
  @IBOutlet weak var table: UITableView!
  
  private let searchController = UISearchController(searchResultsController: nil)
  
  private var searchViewModel = SearchViewModel(cells: [])
  private var timer: Timer?
  
  private lazy var footerView = FooterView()
  weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupSearchBar()
    searchBar(searchController.searchBar, textDidChange: "Pink")
    setupTableView()
    
    
  }
  
  private func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    // не затемняется экран когда вводим что-то в searchBar
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  private func setupTableView() {
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    let nib = UINib(nibName: "TrackCell", bundle: nil)
    table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
    table.tableFooterView = footerView
    
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayTracks(let searchViewModel):
      print("viewController .displayTracks")
      self.searchViewModel = searchViewModel
      table.reloadData()
      footerView.hideLoader()
    case .displayFooterView:
      footerView.showLoader()
    }
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchViewModel.cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
    
    let cellViewModel = searchViewModel.cells[indexPath.row]
    cell.iconImageView.backgroundColor = .red
    cell.configure(viewModel: cellViewModel)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    84
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "Please enter search term above..."
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return searchViewModel.cells.count > 0 ? 0 : 250
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cellViewModel = searchViewModel.cells[indexPath.row]
//    let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
//      .map({$0 as? UIWindowScene})
//      .compactMap({$0})
//      .first?.windows
//      .filter({$0.isKeyWindow}).first
//
//    let trackDetailsView: TrackDetailView = TrackDetailView.loadFromNib()
//    trackDetailsView.configure(viewModel: cellViewModel)
//    trackDetailsView.delegate = self
//    window?.addSubview(trackDetailsView)
    self.tabBarDelegate?.maximizeTrackDetailController(viewModel: cellViewModel)
    
  }
  
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
      self?.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchText: searchText))
    })
  }
}

// MARK: - TrackMovingDelegate
extension SearchViewController: TrackMovingDelegate {
  
  private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
    guard let indexPath = table.indexPathForSelectedRow else  { return nil}
    table.deselectRow(at: indexPath, animated: true)
    var nextIndexPath: IndexPath!
    if isForwardTrack {
      nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
      if nextIndexPath.row == searchViewModel.cells.count {
        nextIndexPath.row = 0
      }
    } else {
      nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
      if nextIndexPath.row == -1 {
        nextIndexPath.row = searchViewModel.cells.count - 1
      }
    }
    table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
    let cellViewModel = searchViewModel.cells[nextIndexPath.row]
    return cellViewModel
  }
  
  func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
    print("go back")
    return getTrack(isForwardTrack: false)
  }
  
  func moveForwardForNextTrack() -> SearchViewModel.Cell? {
    print("go forward")
    return getTrack(isForwardTrack: true)
  }
  
  
}
