//
//  UserDefaults + savedTracks.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 17.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation


extension UserDefaults {
  
  static let favoriteTrackKey = "favoriteTrackKey"
  
  func savedTracks() -> [SearchViewModel.Cell] {
    let defaults = UserDefaults.standard
    guard let savedTracks = defaults.object(forKey: UserDefaults.favoriteTrackKey) as? Data else { return []}
    
    guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return []}
    return decodedTracks
  }
}
