//
//  ArtistTopSongTableViewCell.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 27/3/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ArtistTopSongTableViewCell: UITableViewCell {
    
    
    // MARK: UI Elements
    
    lazy var trackNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.setFontWithColor(.SFUIDisplay, style: .Bold, size: 18, color: UIColor.flatBlack())
        label.numberOfLines = 1
        return label
    }()
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.setFontWithColor(.SFUIDisplay, style: .Medium, size: 12, color: UIColor.flatGray())
        label.numberOfLines = 1
        return label
    }()
    
    lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
        setupUIAppearance()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setup() {
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(albumNameLabel)
    }
    
    private func layout() {
        
        albumCoverImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(55)
            make.top.equalTo(3)
            make.left.equalTo(18)
            make.bottom.equalTo(-3)
        }
        
        trackNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(albumCoverImageView.snp.right).offset(18)
            make.right.equalTo(-18)
        }
        
        albumNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(trackNameLabel.snp.bottom).offset(3)
            make.left.equalTo(albumCoverImageView.snp.right).offset(18)
            make.right.equalTo(-18)
        }

    }
    
    // MARK: Functions
    
    private func setupUIAppearance() {
        
        self.separatorInset = UIEdgeInsets(top: 0, left: 91, bottom: 0, right: 0)
    }
    
    func prepareCell(data: Track) {
        
        trackNameLabel.text = data.trackName
        albumNameLabel.text = data.albumName
        albumCoverImageView.kf.setImage(with: data.albumCoverImage)
    }

}
