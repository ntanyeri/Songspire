//
//  UIButtonExtension.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation

extension UIButton {
    
    func setTextButtonWith(color: UIColor) {
        backgroundColor = UIColor.clear
        titleLabel?.setFont(FontFamily.SFUIDisplay, style: FontStyle.Medium, size: 17)
        setTitleColor(color, for: UIControlState())
    }
    
    func setFontWithColor(font: FontFamily, style: FontStyle, size: CGFloat, titleColor: UIColor, backgroundColor: UIColor, state: UIControlState) {
        self.backgroundColor    = backgroundColor
        self.titleLabel?.font   = UIFont(name: "\(font.rawValue)-\(style.rawValue)", size: size)!
        self.layer.cornerRadius = 8
        self.setTitleColor(titleColor, for: state)
    }
    
    func makeCircularButton() {
        
        layoutIfNeeded()
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}
