//
//  TrackDetailView.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 10.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import AVKit
//import MarqueeLabel

protocol TrackMovingDelegate: class {
  func moveBackForPreviousTrack() -> SearchViewModel.Cell?
  func moveForwardForNextTrack() -> SearchViewModel.Cell?
}

protocol MainTabBarControllerDelegate: class {  
  func minimizeTrackDetailController()
  func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}


class TrackDetailView: UIView {
  
  // MARK: - @IBOutlet
  @IBOutlet weak var trackImageView: UIImageView!
  @IBOutlet weak var currentTimeSlider: UISlider!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var trackTitleLabel: UILabel!
  @IBOutlet weak var authorTitleLabel: UILabel!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var volumeSlider: UISlider!
  
  
  @IBOutlet weak var maximizedStackView: UIStackView!
  
  // MARK: - @IBOutlet MiniPlayer
  
  @IBOutlet weak var miniTrackView: UIView!
  @IBOutlet weak var miniGoForwardButton: UIButton!
  
  @IBOutlet weak var miniPlayPauseButton: UIButton!
  @IBOutlet weak var miniTrackTitleLabel: UILabel!
  @IBOutlet weak var miniTrackImageView: UIImageView!
  
  
  let player: AVPlayer = {
    let avPlayer = AVPlayer()
    //позволяет снизить задержку загрузки до минимума
    avPlayer.automaticallyWaitsToMinimizeStalling = false
    return avPlayer
  }()
  
  weak var delegate: TrackMovingDelegate?
  weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  // MARK: - awakeFromNib()
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let scale: CGFloat = 0.8
    trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    trackImageView.layer.cornerRadius = 5
    
    miniPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
    setupGestures()
    //setupAnimationForLabel()
  }
  
  // MARK: - Configure()
  func configure(viewModel: SearchViewModel.Cell) {
    miniTrackTitleLabel.text = viewModel.trackName
    trackTitleLabel.text = viewModel.trackName
    authorTitleLabel.text = viewModel.artistName
    playTrack(previewUrl: viewModel.previewUrl)
    monitorStartTime()
    observePlayerCurrentTime()
    playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
    // print(string600)
    guard let url = URL(string: string600 ?? "") else { return }
    miniTrackImageView.sd_setImage(with: url, completed: nil)
    trackImageView.sd_setImage(with: url, completed: nil)
  }
  
  private func setupGestures() {
    miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
    miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMximized)))
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
  }
  
  
  
  private func playTrack(previewUrl: String?) {
    
    guard let url = URL(string: previewUrl ?? "") else { return }
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  //MARK: -Maximizing and minimizing gestures
  @objc private func handleTapMaximized() {
    print(#function)
    self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
  }
  
  @objc private func handlePanMximized(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      print("begin")
    case .changed:
      handlePanChanged(gesture: gesture)
    case .ended:
      handlePanEnded(gesture: gesture)
    @unknown default:
      print("unknown default case")
    }
    
  }
  
  private func handlePanChanged(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.superview)
    self.transform = CGAffineTransform(translationX: 0, y: translation.y)
    
    let newAlpha = 1 + translation.y / 200
    self.miniTrackView.alpha = newAlpha < 0 ? 0: newAlpha
    self.maximizedStackView.alpha = -translation.y / 200
  }
  
  private func handlePanEnded(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.superview)
    // скорость
    let velocity = gesture.velocity(in: self.superview)
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.transform = .identity
                    if translation.y < -200 || velocity.y < -500 {
                      self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
                    } else {
                      self.miniTrackView.alpha = 1
                      self.maximizedStackView.alpha = 0
                    }
    },
                   completion: nil)
  }
  
  @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .changed:
      let translation = gesture.translation(in: self.superview)
      maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
    case .ended:
      let translation = gesture.translation(in: self.superview)
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.7,
                     initialSpringVelocity: 1,
                     options: .curveEaseInOut,
                     animations: {
                      self.maximizedStackView.transform = .identity
                      if translation.y > 50 {
                        self.tabBarDelegate?.minimizeTrackDetailController()
                      }
      },
                     completion: nil)
    @unknown default:
      print("unknown default case")
    }
  }
  
  // MARK: - Time setup
  private func monitorStartTime() {
    let time = CMTimeMake(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
      guard let self = self else  { return }
      self.enlargeTrackImageView()
    }
  }
  
  private func observePlayerCurrentTime() {
    let interval = CMTimeMake(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
      guard let self = self else  { return }
      self.currentTimeLabel.text = time.toDisplayString()
      
      let durationTime = self.player.currentItem?.duration
      let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
      self.durationLabel.text = "-\(currentDurationText)"
      self.updateCurrentTimeSlider()
    }
  }
  
  private func updateCurrentTimeSlider() {
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    let percentage = currentTimeSeconds / durationSeconds
    self.currentTimeSlider.value = Float(percentage)
  }
  
  // MARK: - Animations
  private func enlargeTrackImageView() {
    UIView.animate(withDuration: 1,
                   delay: 0,
                   //резкость анимации
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 1,
      options: .curveEaseOut,
      animations: {
        self.trackImageView.transform = .identity
    }, completion: nil)
  }
  private func reduceTrackImageView() {
    UIView.animate(withDuration: 1,
                   delay: 0,
                   //резкость анимации
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 1,
      options: .curveEaseOut,
      animations: {
        let scale: CGFloat = 0.8
        self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }, completion: nil)
  }
  
  //  private func setupAnimationForLabel() {
  //      trackTitleLabel.type = .continuous
  //      trackTitleLabel.speed = .duration(70)
  //      trackTitleLabel.animationCurve = .easeInOut
  //      trackTitleLabel.fadeLength = 10.0
  //      trackTitleLabel.leadingBuffer = 30.0
  //      trackTitleLabel.trailingBuffer = 20.0
  //  }
  
  deinit {
    print(#function)
  }
  
  // MARK: - @IBActions
  @IBAction func dragDownButtonTapped(_ sender: UIButton) {
    self.tabBarDelegate?.minimizeTrackDetailController()
    //self.removeFromSuperview()
  }
  
  @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
    let percentage = currentTimeSlider.value
    guard let duration = player.currentItem?.duration else { return }
    let durationInSeconds = CMTimeGetSeconds(duration)
    let seekTimeInSeconds = Float64(percentage) * durationInSeconds
    let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
    player.seek(to: seekTime)
  }
  
  @IBAction func handleVolumeSlider(_ sender: UISlider) {
    player.volume = volumeSlider.value
  }
  
  @IBAction func previousTrackTapped(_ sender: UIButton) {
    let cellViewModel = delegate?.moveBackForPreviousTrack()
    guard let cellInfo = cellViewModel else { return }
    self.configure(viewModel: cellInfo)
  }
  
  @IBAction func nextTrackTapped(_ sender: UIButton) {
    let cellViewModel = delegate?.moveForwardForNextTrack()
    guard let cellInfo = cellViewModel else { return }
    self.configure(viewModel: cellInfo)
  }
  
  @IBAction func playPauseTapped(_ sender: UIButton) {
    
    if player.timeControlStatus == .paused {
      player.play()
      playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      enlargeTrackImageView()
    } else {
      player.pause()
      playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      reduceTrackImageView()
    }
  }
  
  
}
