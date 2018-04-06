//
//  Artist.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Artist {
        
    let ID              : String
    let followersCount  : Int
    let name            : String
    var externalURL     : URL?
    var image           : URL?
    var genres          : [Genre]?
    
    init(data: JSON) {
        
        
        self.name           = data["name"].stringValue
        self.ID             = data["id"].stringValue
        self.externalURL    = data["external_urls"]["spotify"].url
        self.followersCount = data["followers"]["total"].intValue
        
        
        guard let images = data["images"].array else { return }
        self.image = images[0]["url"].url
        
        if let genres = data["genres"].array {
            self.genres = [Genre]()
            for genre in genres {
                self.genres!.append(Genre(name: genre.stringValue, raputation: 1))
            }
        }
        
    }
    
}
