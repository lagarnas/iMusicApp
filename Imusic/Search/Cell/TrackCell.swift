//
//  TrackCell.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 10.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//


import UIKit
import SDWebImage

protocol TrackCellVoewModel {
  var iconUrlString: String? { get }
  var trackName: String { get }
  var artistName: String { get }
  var collectionName: String { get }
}

class TrackCell: UITableViewCell {
  
  static let reuseId = "TrackCell"
  
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var collectionNameLabel: UILabel!
  
  @IBOutlet weak var addTrackButton: UIButton!
  
  var cell: SearchViewModel.Cell?
  
  // вызывается когда ячейка сконфигурирована через xib файл
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.image = nil
  }
  
  
  @IBAction func addTrackAction(_ sender: Any) {
    let defaults = UserDefaults.standard
    guard let cell = cell else { return }
    var listOfTracks = defaults.savedTracks()
    
    addTrackButton.isHidden = true
    listOfTracks.append(cell)
    
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
      print("Success")
      defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
    }
  }
  
  //MARK: - Configure cell
  func configure(viewModel: SearchViewModel.Cell) {
    
    self.cell = viewModel
    let savedTracks = UserDefaults.standard.savedTracks()
    let hasFavorite = savedTracks.firstIndex {
      $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
    } != nil
    if hasFavorite {
      addTrackButton.isHidden = true
    } else {
      addTrackButton.isHidden = false
    }
    
    trackNameLabel.text = viewModel.trackName
    artistNameLabel.text = viewModel.artistName
    collectionNameLabel.text = viewModel.collectionName
    
    guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
    
    iconImageView.sd_setImage(with: url, completed: nil)
    
  }
}
