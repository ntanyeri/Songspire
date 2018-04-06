//
//  TopArtistTableViewCell.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import CoreMotion

class TopArtistTableViewCell: UITableViewCell {
    
    private weak var shadowView: UIView?
    private var longPressGestureRecognizer: UILongPressGestureRecognizer? = nil
    private var isPressed: Bool = false
    private let motionManager = CMMotionManager()
    
    
    // MARK: UI Elements
    
    lazy var artistName: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Bold, size: 30, color: UIColor.flatWhite())
        label.numberOfLines = 0
        return label
    }()
    
    lazy var artistImageView: UIImageView = {
        let imageView               = UIImageView(frame: CGRect.zero)
        
        imageView.contentMode       = .scaleAspectFill
        imageView.layer.cornerRadius = 14
        
        return imageView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    var visualEffectView: UIVisualEffectView!

    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
        configureGestureRecognizer()
        setupUIAppearance()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    private func setup() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(artistImageView)
        containerView.addSubview(artistName)
    }
    
    private func layout() {
        
        containerView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 20, 10, 20))
        }
        
        artistImageView.snp.makeConstraints({ (make) in
            make.edges.equalTo(containerView).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            make.height.equalTo(containerView)
            make.width.equalTo(containerView)
        })
        
        artistName.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.greaterThanOrEqualTo(50)
        }
        
        
        
    }
    
    // MARK: Functions
    
    private func setupUIAppearance() {
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        AppEngine.addImageOverlay(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000), alpha: 0.2, toView: artistImageView)
        
    }
    
    func prepareCell(data: Artist) {
        
        artistImageView.kf.setImage(with: data.image)
        artistName.text = data.name
    }
    
    // MARK: - Gesture Recognizer
    
    private func configureGestureRecognizer() {
        // Long Press Gesture Recognizer
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer?.minimumPressDuration = 0.1
        addGestureRecognizer(longPressGestureRecognizer!)
    }
    
    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            handleLongPressBegan()
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            handleLongPressEnded()
        }
    }
    
    private func handleLongPressBegan() {
        guard !isPressed else {
            return
        }
        
        isPressed = true
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    private func handleLongPressEnded() {
        guard isPressed else {
            return
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform.identity
        }) { (finished) in
            self.isPressed = false
        }
    }
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: 20,
                                              y: 20,
                                              width: bounds.width - (2 * 20),
                                              height: bounds.height - (2 * 20)))
        
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        applyShadow(width: 1, height: 8)
        
        // Roll/Pitch Dynamic Shadow
//        if motionManager.isDeviceMotionAvailable {
//            motionManager.deviceMotionUpdateInterval = 0.02
//            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
//                if let motion = motion {
//                    let pitch = motion.attitude.pitch * 10 // x-axis
//                    let roll = motion.attitude.roll * 10 // y-axis
//
//
//                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
//                }
//            })
//        }
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.35
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }

}
