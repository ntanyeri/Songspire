//
//  TopArtistsViewModal.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TopArtistsViewModalDelegate {
    
    func didSuccessGetLongTernTopArtistList()
    func didSuccessGetMediumTernTopArtistList()
    func didSuccessGetShortTernTopArtistList()
    func didFailureBackendRequest(messages: String)
}

class TopArtistsViewModal {
    
    let delegate: TopArtistsViewModalDelegate?
    private let spotifyAPI: Spotify!
    
    var topArtistData   = [Int: [Artist]]()
    var sectionInfos    = [SectionInfo]()
    
    init(delegate: TopArtistsViewModalDelegate?) {
        
        self.delegate       = delegate
        spotifyAPI          = Spotify()
        spotifyAPI.delegate = self

        prepareSectionInfos()
    }
    
    private func prepareSectionInfos() {
        
        topArtistData = [0: [Artist](), 1: [Artist](), 2: [Artist]()]
        sectionInfos.append(SectionInfo(title: "THIS MONTH", isVisible: false))
        sectionInfos.append(SectionInfo(title: "THIS YEAR", isVisible: false))
        sectionInfos.append(SectionInfo(title: "ALL TIME", isVisible: false))
    }
    
    func getLongTermTopArtist() {
        spotifyAPI.sendGETUserTopList(type: UserTop.artists, timeRange: TimeRange.longTerm)
    }
    func getMediumTermTopArtist() {
        spotifyAPI.sendGETUserTopList(type: UserTop.artists, timeRange: TimeRange.mediumTerm)
    }
    func getShortTermTopArtist() {
        spotifyAPI.sendGETUserTopList(type: UserTop.artists, timeRange: TimeRange.shortTerm)
    }
}

extension TopArtistsViewModal: SpotifyWebAPIDelegate {
    
    func spotifyWebAPIDidRequestSuccess(data: Any, endpoint: Endpoint) {
        
        let jsonObject  = JSON(data)
        
        if let topArtists = jsonObject["items"].array {
            for topArtist in topArtists {
                
                let artist = Artist(data: topArtist)
                
                if let nextURL     = jsonObject["next"].url {
                    if let range = nextURL.valueOf("time_range") {
                        let timeRange = TimeRange(rawValue: range) ?? .none
                        
                        switch timeRange {
                        case .longTerm:
                            topArtistData[2]!.append(artist)
                            sectionInfos[2].isVisible = true
                            delegate?.didSuccessGetLongTernTopArtistList()
                            
                        case .mediumTerm:
                            // Eğer medium range request yaparsak, next url içerisinde time range değeri olmuyor.
                            break
                        case .shortTerm:
                            topArtistData[0]!.append(artist)
                            sectionInfos[0].isVisible = true
                            delegate?.didSuccessGetShortTernTopArtistList()
                        case .none:
                            break
                        }
                    } else {
                        topArtistData[1]!.append(artist)
                        sectionInfos[1].isVisible = true
                        delegate?.didSuccessGetMediumTernTopArtistList()
                    }
                }
            }
        }
    }
    
    func spotifyWebAPIDidRequestFailure(error: BackendError, data: Any?, endpoint: Endpoint) {
        
        delegate?.didFailureBackendRequest(messages: "Ahoy!")
    }
}
