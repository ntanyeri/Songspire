//
//  URLExtension.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 18/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
