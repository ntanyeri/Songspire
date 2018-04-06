//
//  MusicPlayerViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 26/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import Chameleon
import LNPopupController
import SnapKit
import MediaPlayer


protocol MusicPlayerViewControllerDelegate {
    func didPressPlayButton()
    func didPressPauseButton()
}

class MusicPlayerViewController: UIViewController {
    
    // MARK: Variables
    
    var delegate: MusicPlayerViewControllerDelegate?
    var timer: Timer!
    var playBarButton: UIBarButtonItem!
    var pauseBarButton: UIBarButtonItem!
    
    var artistName: String = "" {
        didSet {
            if isViewLoaded {
                artistNameLabel.text = artistName
            }
        }
    }
    
    var trackName: String = "" {
        didSet {
            if isViewLoaded {
                trackNameLabel.text = trackName
            }
            
            popupItem.title = trackName
            popupItem.rightBarButtonItems = [ pauseBarButton ] // Refresh
            playPauseToggleButton.isSelected = true
        }
    }
    var albumName: String = "" {
        didSet {
            if isViewLoaded {
                //albumNameLabel.text = albumTitle
            }
            
            popupItem.subtitle = albumName
        }
    }
    
    var albumArt: UIImage = UIImage() {
        didSet {
            if isViewLoaded {
                backgroundImageView.image = albumArt
                albumArtImageView.image = albumArt
            }
            popupItem.image = albumArt
            popupItem.accessibilityImageLabel = NSLocalizedString("Album Art", comment: "")
        }
    }
    
    var totalDuration: Double = 0 {
        didSet {
            totalDurationLabel.text = timeString(time: TimeInterval(totalDuration))
            currentDuration = 0
            timer?.invalidate() // reset timer
            startTimer()
        }
    }
    
    var currentDuration: Double = 0
    
    
    // MARK: UI Elements
    
    lazy var backgroundBlurView: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var albumArtImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setFontWithColor(.SFUIDisplay, style: FontStyle.Bold, size: 32, color: UIColor.flatWhite())
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setFontWithColor(.SFUIDisplay, style: FontStyle.Regular, size: 20, color: UIColor.flatWhite())
        return label
    }()
    
    lazy var playPauseToggleButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        
        button.addTarget(self, action: #selector(self.playePauseToggleButtonAction(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "playBig"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "pauseBig"), for: UIControlState.selected)
        button.backgroundColor = UIColor.flatWhite()
        button.layer.masksToBounds = true
        
        button.layer.shadowColor = UIColor.flatWhite().cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 0.5
        button.layer.cornerRadius = button.frame.width / 2
        
        return button
    }()
    
    lazy var volumeView: MPVolumeView = {
        let view = MPVolumeView(frame: CGRect.zero)
        view.tintColor = UIColor.flatYellow()
        return view
    }()
    
    lazy var durationBarView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect.zero)
        progressView.progressTintColor = UIColor.flatYellow()
        return progressView
    }()
    
    lazy var currentDurationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "0:00"
        label.setFontWithColor(.SFUIDisplay, style: FontStyle.Light, size: 9, color: UIColor.white)
        return label
    }()
    
    lazy var totalDurationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "0:00"
        label.setFontWithColor(.SFUIDisplay, style: FontStyle.Light, size: 9, color: UIColor.white)
        return label
    }()

    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        
        playBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "play"), style: .plain, target: self, action: #selector(self.playButtonAction(_:)))
        pauseBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "pause"), style: .plain, target: self, action: #selector(self.pauseButtonAction(_:)))
        
        popupItem.rightBarButtonItems = [ pauseBarButton ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        print(AVAudioSession.sharedInstance().outputVolume)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playPauseToggleButton.makeCircularButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Setup
    
    func setup() {

        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(backgroundBlurView)
        view.addSubview(albumArtImageView)
        view.addSubview(trackNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(playPauseToggleButton)
        view.addSubview(volumeView)
        view.addSubview(durationBarView)
        view.addSubview(currentDurationLabel)
        view.addSubview(totalDurationLabel)
        
        layout()
    }
    
    func layout() {
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        backgroundBlurView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.backgroundImageView)
        }
        
        albumArtImageView.snp.makeConstraints { (make) in
            make.top.equalTo(55)
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.width.height.equalTo(view.frame.width - 72)
        }
        
        trackNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumArtImageView.snp.bottom).offset(25)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        artistNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(trackNameLabel.snp.bottom).offset(8)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(30)
        }
        
        durationBarView.snp.makeConstraints { (make) in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(10)
            make.left.equalTo(currentDurationLabel.snp.right).offset(10)
            make.right.equalTo(totalDurationLabel.snp.left).offset(-10)
        }
        
        currentDurationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(durationBarView)
            make.left.equalTo(60)
            make.right.equalTo(durationBarView.snp.left).offset(-10)
            make.height.equalTo(11)
        }
        
        totalDurationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(durationBarView)
            make.right.equalTo(-60)
            make.left.equalTo(durationBarView.snp.right).offset(10)
            make.height.equalTo(11)
        }
        
        playPauseToggleButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(durationBarView.snp.bottom).offset(30)
            make.width.height.equalTo(100)
        }
        
        volumeView.snp.makeConstraints { (make) in
            make.top.equalTo(playPauseToggleButton.snp.bottom).offset(30)
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.height.equalTo(30)
        }
        
    }
    
    
    // MARK: Actions
    
    @objc func playButtonAction(_ sender: UIBarButtonItem) {
        
        startTimer()
        delegate?.didPressPlayButton()
        popupItem.rightBarButtonItems = [ pauseBarButton ]
        playPauseToggleButton.isSelected = true
    }
    
    @objc func pauseButtonAction(_ sender: UIBarButtonItem) {
        
        stopTimer()
        delegate?.didPressPauseButton()
        popupItem.rightBarButtonItems = [ playBarButton ]
        playPauseToggleButton.isSelected = false
    }
    
    @objc func playePauseToggleButtonAction(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            popupItem.rightBarButtonItems = [ playBarButton ]
            delegate?.didPressPauseButton()
            stopTimer()
        } else {
            sender.isSelected = true
            popupItem.rightBarButtonItems = [ pauseBarButton ]
            delegate?.didPressPlayButton()
            startTimer()
        }
    }
    
    @objc func updateDuration(_ timer: Timer) {
        
        currentDuration += 1
        currentDurationLabel.text = timeString(time: TimeInterval(currentDuration))
        durationBarView.setProgress(Float(currentDuration/totalDuration), animated: true)
        
        if durationBarView.progress >= 1.0 {
            stopTimer()
            popupPresentationContainer?.dismissPopupBar(animated: true, completion: nil)
        }
    }
    
    
    // MARK: Fucntions
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDuration(_:)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func timeString(time: TimeInterval) -> String {
        
        //let hours   = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String("\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
