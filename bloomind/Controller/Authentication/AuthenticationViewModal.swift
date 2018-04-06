//
//  AuthenticationViewModal.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation

protocol AuthenticationViewModalDelegate {
    
    func didSuccessAuthentication()
    func didFailureAuthentication()
}

class AuthenticationViewModal {
    
    let delegate: AuthenticationViewModalDelegate?
    
    init(delegate: AuthenticationViewModalDelegate) {
        
        self.delegate = delegate
    }
    
    
    
    
}
