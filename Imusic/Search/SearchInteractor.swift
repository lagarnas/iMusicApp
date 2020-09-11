//
//  SearchInteractor.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright (c) 2020 lagarnas. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
  
  var networkService = NetworkService()
  
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    
    switch request {
    case .getTracks(let searchText):
      print("interactor .getTracks")
      presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
      networkService.fetchTracks(searchText: searchText) { [weak self] searchResponse in
        guard let self = self else { return }
        self.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
      }
    }
  }
  
  
}
