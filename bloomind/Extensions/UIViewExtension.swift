//
//  UIViewExtension.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 3/3/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation

extension UIView {
    
    func addBlurEffect(alpha: CGFloat, style: UIBlurEffectStyle) {
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = alpha
        self.addSubview(blurEffectView)
    }
}
