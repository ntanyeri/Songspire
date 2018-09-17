//
//  Spotify.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation
import Alamofire


protocol SpotifyWebAPIDelegate {
    
    func spotifyWebAPIDidRequestSuccess(data: Any, endpoint: Endpoint)
    func spotifyWebAPIDidRequestFailure(error: BackendError, data: Any?, endpoint: Endpoint)
}

class Spotify {
    
    let clientID    = "YOUR_CLIENT_ID"
    let redirectURI = URL(string: "songspire://")!
    let sessionKey  = "spotifySessionKey"
    let appURL      = SPTAuth.defaultInstance().spotifyAppAuthenticationURL()!
    let webURL      = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()!
    let userDefaults = UserDefaults.standard
    
    var delegate: SpotifyWebAPIDelegate?
    
    func sendGETUserTopList(type: UserTop, timeRange: TimeRange) {
        
        let endpoint    = Endpoint.meTop
        let method      = HTTPMethod.get
        let header      = endpoint.header
        let customURL   = URL(string: endpoint.URL.absoluteString + "/\(type.rawValue)")!
        var body        = [String: Any]()
        
        body["time_range"] = timeRange.rawValue
        
        performRequest(method: method, endpoint: endpoint, paramaters: body, header: header, customURL: customURL)
    }
    
    func sendGetArtistTopTracks(withID id: String) {
        
        let endpoint    = Endpoint.artist
        let method      = HTTPMethod.get
        let header      = endpoint.header
        let customURL   = URL(string: endpoint.URL.absoluteString + "/\(id)/top-tracks")!
        var body        = [String: Any]()

        body["country"] = userDefaults.string(forKey: "UserRregionCode") ?? "US"
        
        performRequest(method: method, endpoint: endpoint, paramaters: body, header: header, customURL: customURL)
    }
}

extension Spotify {
    
    internal func performRequest(method: HTTPMethod, endpoint: Endpoint, paramaters: [String: Any]?, header: [String: String]?, customURL: URL?) {
        
        var requestURL: URL
        
        if let customRequestURL = customURL {
            requestURL = customRequestURL
        }
        else {
            requestURL = endpoint.URL
        }
        
        let request =  Alamofire.SessionManager.default.request(requestURL, method: method, parameters: paramaters, headers: header).validate(statusCode: 200..<500).responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
                
            case .success(let value):
                
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                        self.delegate?.spotifyWebAPIDidRequestSuccess(data: value, endpoint: endpoint)
                    default:
                        let error = BackendError(rawValue: statusCode) ?? .notFound
                        self.delegate?.spotifyWebAPIDidRequestFailure(error: error, data: value, endpoint: endpoint)
                    }
                }
                
            case .failure:
                self.delegate?.spotifyWebAPIDidRequestFailure(error: .notFound, data: nil, endpoint: endpoint)
                
            }
        }
        print(request)
    }
}


public enum Endpoint: String {
    
    static let baseURL = Foundation.URL(string: APIEnviorment.production.rawValue)
    
    // Personalization
    case meTop   = "v1/me/top"
    case artist  = "v1/artists"
    
    var URL: Foundation.URL{
        return Foundation.URL(string: self.rawValue, relativeTo: Endpoint.baseURL)!
    }
    
    var header: [String: String]?{
        
        if SPTAuth.defaultInstance().session.isValid() {
            if let token = SPTAuth.defaultInstance().session.accessToken {
                return ["Authorization": "Bearer " + token]
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
}

enum APIEnviorment : String {
    case production     = "https://api.spotify.com"
    case development    = ""
}


// MARK: - Error Types

enum BackendError: Int {
    case notAcceptable  = 406 // Form Errors
    case forbidden      = 403 // Bearer Token Errors
    case unauthorized   = 401 // Unauthorized Process
    case other          = 504 // Gateway Timeout
    case notFound       = 404 // Not Found
}

enum UserTop: String {
    case artists    = "artists"
    case tracks     = "tracks"
}

enum TimeRange: String {
    case longTerm   = "long_term"   // calculated from several years of data and including all new data as it becomes available
    case mediumTerm = "medium_term" // approximately last 6 months
    case shortTerm  = "short_term"  // approximately last 4 weeks
    case none       = ""
}

enum Bitrate: UInt {
    
    case low = 0
    case normal = 1
    case high = 2
    
    var displayValue: String? {
        switch self {
        case .low:
            return "~96kbit/sec"
        case .normal:
            return "~160kbit/sec"
        case .high:
            return "~320kbit/sec"
        }
    }
}

