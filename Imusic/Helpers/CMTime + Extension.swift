//
//  CMTime + Extension.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 11.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
  
  func toDisplayString() -> String {
    guard !CMTimeGetSeconds(self).isNaN else { return ""}
    let totalSeconds = Int(CMTimeGetSeconds(self))
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60
    let timeFormatString = String(format: "%02d: %02d", minutes, seconds)
    return timeFormatString
  }
}
