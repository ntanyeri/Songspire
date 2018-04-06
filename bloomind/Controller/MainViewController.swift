//
//  MainViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 1/4/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher


class MainViewController: UIViewController {
    
    // MARK: Variables
    var popupContentController: MusicPlayerViewController!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMusicPlayer()
        prepareSpotifyPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainViewController {
    
    func initMusicPlayer() {
        popupContentController = storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        popupContentController.delegate = self
    }
    
    func prepareSpotifyPlayer() {
        
        SPTAudioStreamingController.sharedInstance().delegate = self
        SPTAudioStreamingController.sharedInstance().playbackDelegate = self
        SPTAudioStreamingController.sharedInstance().login(withAccessToken: SPTAuth.defaultInstance().session.accessToken)
    }
    
    func preparePopupContentController(withTrack track: Track) {
        
        popupContentController.trackName        = track.trackName
        popupContentController.albumName        = track.albumName
        popupContentController.totalDuration    = track.trackDuration
        popupContentController.artistName       = track.artistName
        
        if let albumArt = track.albumCoverImage {
            KingfisherManager.shared.retrieveImage(with: albumArt, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
                self.popupContentController.albumArt = image!
            }
        }
    }
    
    func playTrack(withID: String) {
        
        SPTAudioStreamingController.sharedInstance().playSpotifyURI("spotify:track:\(withID)", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            print("Track Playing")
        })
    }
}

// MARK: Spotify SDK Delegates

extension MainViewController: SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
    }
}


// MARK: Music Player Delegates

extension MainViewController: MusicPlayerViewControllerDelegate {
    
    func didPressPlayButton() {
        SPTAudioStreamingController.sharedInstance().setIsPlaying(true) { (error) in
            print("Current Track Playing")
        }
    }
    
    func didPressPauseButton() {
        SPTAudioStreamingController.sharedInstance().setIsPlaying(false) { (error) in
            print("Current Track Paused")
        }
    }
}
