//
//  TopTrackCollectionViewCell.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 18/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import SnapKit

class TopTrackCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: UI Elements
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Regular, size: 15, color: UIColor.flatBlack())
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        
        label.setFontWithColor(.SFUIDisplay, style: FontStyle.Medium, size: 17, color: UIColor.flatRedColorDark())
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var trackNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        
        label.setFontWithColor(.SFUIDisplay, style: FontStyle.Bold, size: 17, color: UIColor.flatBlack())
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var albumCoverImageView: UIImageView = {
        
        let imageView               = UIImageView(frame: CGRect.zero)
        
        imageView.contentMode       = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()

    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
        setupUIAppearance()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Setup
    
    private func setup() {
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(trackNameLabel)
    }
    
    private func layout() {
        
        albumCoverImageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.width.height.equalTo(contentView.frame.width)
            make.bottom.equalTo(-(contentView.frame.width - (contentView.frame.height/2.39)))
        }
        
        trackNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumCoverImageView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        artistNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(trackNameLabel.snp.bottom).offset(2)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
     
    }
    
    
    // MARK: Functions
    
    private func setupUIAppearance() {
        
        backgroundColor     = UIColor.white
        layer.cornerRadius  = 8
        layer.masksToBounds = true
        
    }
    
    func prepareCell(data: Track) {
        
        trackNameLabel.text     = data.trackName
        artistNameLabel.text    = data.artistName
        albumNameLabel.text     = data.albumName
        albumCoverImageView.kf.setImage(with: data.albumCoverImage)
        
    }
    
}
