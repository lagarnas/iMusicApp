//
//  SearchResponse.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
  var resultCount: Int
  var results: [Track]
}
struct Track: Decodable {
  var trackName: String
  var collectionName: String?
  var artistName: String
  var artworkUrl100: String?
  var previewUrl: String?
}
