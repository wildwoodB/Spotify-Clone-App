//
//  PlaybackPresenter.swift
//  SpotifyAppProject
//
//  Created by Админ on 08.05.2023.
//
import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? {get}
    var subtitle: String? {get}
    var imageUrl: URL? {get}
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    private var playerIsPlaying: Bool {
            guard let trackPlayer = player else { return false }
            if trackPlayer.timeControlStatus == .playing { return true }
            else { return false }
        }
    
    var player: AVPlayer?
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.1
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true ) { [weak self] in
            self?.player?.play()
        }
        
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        self.tracks = tracks
        self.track = nil
        let vc = PlayerViewController()
        vc.title = tracks.first?.name
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func didChangeSlider(value: Float) {
        guard let trackPlayer = player else { return }
        trackPlayer.volume = value
    }
    
    func didTapPlayPause() {
        guard let trackPlayer = player else { return }
                if playerIsPlaying { trackPlayer.pause() }
                else { trackPlayer.play() }
        }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else {
            
        }
    }
    
    func didTApBacward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else {
            
        }
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
