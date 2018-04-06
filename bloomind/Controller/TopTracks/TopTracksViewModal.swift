//
//  TopTracksViewModal.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TopTracksViewModalDelegate {
    
    func didSuccessGetLongTernTopTrackList()
    func didSuccessGetMediumTernTopTrackList()
    func didSuccessGetShortTernTopTrackList()
    func didFailureBackendRequest(messages: String)
}

class TopTracksViewModal {
    
    let delegate    : TopTracksViewModalDelegate?
    let spotifyAPI  : Spotify!
    
    var longTermTopTracktList   = [Track]()
    var mediumTermTopTrackList  = [Track]()
    var shortTermTopTrackList   = [Track]()
    var sectionInfos            = [SectionInfo]()
    
    init(delegate: TopTracksViewModalDelegate) {
        
        self.delegate       = delegate
        spotifyAPI          = Spotify()
        spotifyAPI.delegate = self
        
        prepareSectionInfos()
    }
    
    func prepareSectionInfos() {
        sectionInfos.append(SectionInfo(title: "THIS MONTH", isVisible: false))
        sectionInfos.append(SectionInfo(title: "THIS MONTH", isVisible: false))
        sectionInfos.append(SectionInfo(title: "THIS MONTH", isVisible: false))
    }
    
    func getLongTermTopTracks() {
        spotifyAPI.sendGETUserTopList(type: UserTop.tracks, timeRange: TimeRange.longTerm)
    }
    func getMediumTermTopTracks() {
        spotifyAPI.sendGETUserTopList(type: UserTop.tracks, timeRange: TimeRange.mediumTerm)
    }
    func getShortTermTopTracks() {
        spotifyAPI.sendGETUserTopList(type: UserTop.tracks, timeRange: TimeRange.shortTerm)
    }
}

extension TopTracksViewModal: SpotifyWebAPIDelegate {
    
    func spotifyWebAPIDidRequestSuccess(data: Any, endpoint: Endpoint) {
        
        let jsonObject  = JSON(data)
        
        
        if let topTracks = jsonObject["items"].array {
            for topTrack in topTracks {
                
                let track = Track(data: topTrack)
                
                if let nextURL = jsonObject["next"].url {
                    if let range = nextURL.valueOf("time_range") {
                        let timeRange = TimeRange(rawValue: range) ?? .none
                        
                        switch timeRange {
                        case .longTerm:
                            longTermTopTracktList.append(track)
                            sectionInfos[2].isVisible = true
                            delegate?.didSuccessGetLongTernTopTrackList()
                        case .mediumTerm:
                            // Eğer medium range request yaparsak, next url içerisinde time range değeri olmuyor.
                            break
                        case .shortTerm:
                            shortTermTopTrackList.append(track)
                            sectionInfos[0].isVisible = true
                            delegate?.didSuccessGetShortTernTopTrackList()
                        case .none:
                            break
                        }
                    } else {
                        mediumTermTopTrackList.append(track)
                        sectionInfos[1].isVisible = true
                        delegate?.didSuccessGetMediumTernTopTrackList()
                    }
                }
            }
        }
    }
    
    func spotifyWebAPIDidRequestFailure(error: BackendError, data: Any?, endpoint: Endpoint) {
        
        delegate?.didFailureBackendRequest(messages: "Ahoy!")
    }
}
