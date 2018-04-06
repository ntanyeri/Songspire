//
//  ArtistDetailViewModal.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 27/3/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ArtistDetailViewModalDeletage {
    
    func didSuccessGetTopTracksList()
    func didFailureBackendRequest(messages: String)
}

class ArtistDetailViewModal {
    
    // MARK: Variables
    
    var delegate: ArtistDetailViewModalDeletage?
    let spotifyAPI: Spotify!
    
    var artistData: Artist!
    var topTracks = [Track]()
    
    // MARK: Lifecycle
    
    init(delegate: ArtistDetailViewModalDeletage?) {
        
        self.delegate = delegate
        spotifyAPI = Spotify()
        spotifyAPI.delegate = self
    }
    
    convenience init(withData data: Artist) {

        self.init(delegate: nil)
        self.artistData = data
    }
    
    // MARK: Functions
    
    func getTopTracks() {
        
        spotifyAPI.sendGetArtistTopTracks(withID: artistData.ID)
    }
    
}

extension ArtistDetailViewModal: SpotifyWebAPIDelegate {
    
    func spotifyWebAPIDidRequestSuccess(data: Any, endpoint: Endpoint) {
        
        let jsonObject  = JSON(data)
        
        
        if let tracks = jsonObject["tracks"].array {
            for track in tracks {
                topTracks.append(Track(data: track))
            }
        }
        delegate?.didSuccessGetTopTracksList()
    }
    
    func spotifyWebAPIDidRequestFailure(error: BackendError, data: Any?, endpoint: Endpoint) {
        
        delegate?.didFailureBackendRequest(messages: "Upps")
    }
}
