//
//  MoreViewModal.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 3/3/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation

protocol MoreViewModalDelegate {
    func didSuccessUserInfoRequest()
    func didFailureUserInfoRequest(messages: String?)
}

class MoreViewModal {
    
    var delegate: MoreViewModalDelegate?
    var userInfo: SPTUser?
    
    let sectionZero = ["Streaming Quality", "Region*"]
    let sectionOne = ["Rate App", "Share App"]
    let sectionTwo = ["Version", "Build"]
    let sectionThree = ["Sign out"]
    let tableViewData: [Int: [String]]
    let userDefaults = UserDefaults.standard
    
    init(delegate: MoreViewModalDelegate) {
        self.delegate = delegate
        
        tableViewData = [0: sectionZero, 1: sectionOne, 2: sectionTwo, 3: sectionThree]
    }
    
    func getSPTUserInfo() {
        
        SPTUser.requestCurrentUser(withAccessToken: SPTAuth.defaultInstance().session.accessToken) { (error, response) in
            if error != nil {
                self.delegate?.didFailureUserInfoRequest(messages: error?.localizedDescription)
            } else {
                if let user = response as? SPTUser {
                    self.userInfo = user
                    self.delegate?.didSuccessUserInfoRequest()
                }
            }
        }
    }
    
    func removeSession() {
        userDefaults.removeObject(forKey: "SpotifySession")
        userDefaults.synchronize()
    }
    
    func changeRegionWith(regionCode: String) {
        userDefaults.set(regionCode, forKey: "UserRregionCode")
        userDefaults.synchronize()
    }
    
    func getRegionOfUser() -> String? {
        
        guard let regionCode = userDefaults.string(forKey: "UserRregionCode") else { return nil }
        let countryName = Locale.current.localizedString(forRegionCode: regionCode)
        return countryName
    }
}

