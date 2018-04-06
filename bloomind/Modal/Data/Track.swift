//
//  Track.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 18/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Track {
    
    let ID              : String
    let albumName       : String
    var albumCoverImage : URL?
    let artistName      : String
    let trackName       : String
    let trackDuration   : Double
    
    init(data: JSON) {
        
        self.ID         = data["id"].stringValue
        self.albumName  = data["album"]["name"].stringValue
        self.trackName  = data["name"].stringValue
        self.trackDuration = data["duration_ms"].doubleValue / 1000 // millisecond to second
        
        if let artists = data["artists"].array {
            self.artistName = artists[0]["name"].stringValue
        } else {
            artistName = ""
        }
        
        if let images = data["album"]["images"].array {
            self.albumCoverImage = images[0]["url"].url
        }
    }
}
