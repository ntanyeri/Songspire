//
//  AppEngine.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation
import Chameleon

open class AppEngine {
    
    open class func setUIElementsAppearances() {
        
        UINavigationBar.appearance().tintColor = UIColor.flatWhite()
        UINavigationBar.appearance().barTintColor = HexColor("F4B93E")
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()

        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.flatWhite()]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.flatWhite()]
        
        UITabBar.appearance().backgroundColor   = HexColor("F4B93E")
        UITabBar.appearance().tintColor         = HexColor("F4B93E")
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    open class func addImageOverlay(frame: CGRect, alpha: CGFloat, toView: UIView ) {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        toView.addSubview(view)
    }
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    
    open class func getVersionNumber() -> String {
        let dictionary = Bundle.main.infoDictionary!
        return dictionary["CFBundleShortVersionString"] as! String
    }
    
    open class func getBuildNumber() -> String {
        let dictionary = Bundle.main.infoDictionary!
        return dictionary["CFBundleVersion"] as! String
    }
}

class SectionInfo {
    
    let title: String
    var isVisible: Bool
    
    init(title: String, isVisible: Bool) {
        self.title = title
        self.isVisible = isVisible
    }
}
