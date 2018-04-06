//
//  PlayerObject.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 26/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation

class PlayerObject {
    
    var track: Track
    var currentPosition: TimeInterval
    
    init(track: Track, currentPosition: TimeInterval) {
        self.track              = track
        self.currentPosition    = currentPosition
    }
}
