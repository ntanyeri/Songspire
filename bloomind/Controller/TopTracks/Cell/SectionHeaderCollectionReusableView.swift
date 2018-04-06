//
//  SectionHeaderCollectionReusableView.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 18/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import SnapKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: UI Elements
    
    lazy var title: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Medium, size: 15, color: .flatGrayColorDark())
        label.numberOfLines = 1
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(title)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clear
    }
    
    
    // MARK: Functions
    
    func setup() {
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(0)
        }
    }
        
}
