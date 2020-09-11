//
//  NetworkService.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NetworkService {
  func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
    let url = "https://itunes.apple.com/search?term=\(searchText)"
    let parameters = [ "term": "\(searchText)",
                      "limit": "100",
                      "media": "music"]
    
    AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseData { (dataResponse) in
      if let error = dataResponse.error {
        print(error.localizedDescription)
        completion(nil)
        return
      }
      guard let data = dataResponse.data else { return }
      
      let decoder = JSONDecoder()
      do {
        let objects = try decoder.decode(SearchResponse.self, from: data)
        //print(objects)
        completion(objects)

      } catch let jsonError{
        print(jsonError.localizedDescription)
        completion(nil)
      }
    }
  }
}
