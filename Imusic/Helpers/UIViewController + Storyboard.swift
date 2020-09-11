//
//  UIViewController + Storyboard.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 09.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  class func loadFromStoryboard<T: UIViewController>() -> T {
    let name = String(describing: T.self)
    let storyboard = UIStoryboard(name: name, bundle: nil)
    if let vc = storyboard.instantiateInitialViewController() as? T {
      return vc
    } else {
      fatalError("Error: No initial view controller in \(name) storyboard")
    }
  }
}
