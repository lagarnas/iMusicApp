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
  
  
  // вызывается когда ячейка сконфигурирована через xib файл
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.image = nil
  }
  
  func configure(viewModel: TrackCellVoewModel) {
    trackNameLabel.text = viewModel.trackName
    artistNameLabel.text = viewModel.artistName
    collectionNameLabel.text = viewModel.collectionName
    
    guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
    
    iconImageView.sd_setImage(with: url, completed: nil)
    
    
  }
}
