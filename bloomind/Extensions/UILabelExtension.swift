//
//  UILabelExtension.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation

extension UILabel {
    
    func setFontWithColor(_ font: FontFamily, style: FontStyle, size: CGFloat, color: UIColor) {
        self.textColor  = color
        self.font       = UIFont(name: "\(font.rawValue)-\(style.rawValue)", size: size)!
    }
    
    func setFont(_ font: FontFamily, style: FontStyle, size: CGFloat) {
        self.font = UIFont(name: "\(font.rawValue)-\(style.rawValue)", size: size)!
    }
    
    func setCircularLabelWithFont(_ font: FontFamily, style: FontStyle, size: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
        self.font = UIFont(name: "\(font.rawValue)-\(style.rawValue)", size: size)!
    }
    
    func setCircularLabelWithFontAndColor(_ font: FontFamily, style: FontStyle, size: CGFloat, color: UIColor) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
        self.textColor  = color
        self.font = UIFont(name: "\(font.rawValue)-\(style.rawValue)", size: size)!
    }
    
}
