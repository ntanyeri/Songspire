//
//  AuthenticationViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import SafariServices
import SnapKit
import Chameleon

class AuthenticationViewController: UIViewController, SPTAudioStreamingDelegate {

    // MARK: Variables
    
    var safariViewController: SFSafariViewController!
    
    
    // MARK: UI Elements
    
    lazy var signinButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("LET STARTED", for: .normal)
        button.addTarget(self, action: #selector(self.spotifySigninAction(_:)), for: .touchUpInside)
        
        button.setFontWithColor(font: FontFamily.SFUIDisplay, style: FontStyle.Bold, size: 17, titleColor: UIColor.flatWhite(), backgroundColor: HexColor("73C700"), state: UIControlState.normal)
        
        return button
    }()
    
    lazy var pageIcon: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "headphone")
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label             = UILabel(frame: CGRect.zero)
        
        label.text                      = "You are what you stream"
        label.textAlignment             = NSTextAlignment.center
        label.numberOfLines             = 1
        label.adjustsFontSizeToFitWidth = true
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Bold, size: 32, color: UIColor.flatWhite())
        
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label             = UILabel(frame: CGRect.zero)
        
        label.text                      = "Visualize your most listened artists and tracks on Spotify"
        label.textAlignment             = NSTextAlignment.center
        label.numberOfLines             = 0
        label.adjustsFontSizeToFitWidth = true
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Medium, size: 20, color: UIColor.flatWhite())
        
        return label
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Setup
    
    func setup() {
        
        view.backgroundColor = HexColor("F4B93E")
        
        view.addSubview(signinButton)
        view.addSubview(pageIcon)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        layout()
    }
    
    func layout() {
        
        pageIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(175)
            make.top.equalTo(96)
            make.left.equalTo(120)
            make.right.equalTo(-119)
            make.bottom.equalTo(titleLabel.snp.top).offset(-95)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pageIcon.snp.bottom).offset(95)
            make.left.equalTo(30)
            make.right.equalTo(-29)
            make.bottom.equalTo(messageLabel.snp.top).offset(-15)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(90)
            make.right.equalTo(-89)
            make.height.equalTo(72)
            //make.bottom.equalTo(signinButton.snp.top).offset(-123)
        }
        
        signinButton.snp.makeConstraints { (make) in
            //make.top.equalTo(messageLabel.snp.bottom).offset(123)
            make.left.equalTo(36)
            make.height.equalTo(50)
            make.right.equalTo(-35)
            make.bottom.equalTo(-125)
        }
    }
    
    // MARK: Functions
    
    @objc func receievedUrlFromSpotify(_ notification: Notification) {
        
        guard let url = notification.object as? URL else { return }
        
        
        // Close the web view if it exists
        if safariViewController != nil {
            safariViewController.dismiss(animated: true, completion: nil)
        }
        
        
        // Remove the observer from the Notification Center
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.Spotify.authURLOpened,
                                                  object: nil)
        
        SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
            if let error = error {
                // Pass our error onto another method which will determine how to show it
                self.displayErrorMessage(error: error)
                return
            }
            
            if let session = session {
                
                let userDefaults    = UserDefaults.standard
                let sessionData     = NSKeyedArchiver.archivedData(withRootObject: session)
                
                userDefaults.set(sessionData, forKey: "SpotifySession")
                userDefaults.synchronize()
                
                // The streaming login is asyncronious and will alert us if the user
                // was logged in through a delegate, so we need to implement those methods
                
                SPTAudioStreamingController.sharedInstance().delegate = self
                SPTAudioStreamingController.sharedInstance().login(withAccessToken: session.accessToken)
                
                Router.pushHomeViewController(target: self)

            }
        }
        
        
    }
    
    func displayErrorMessage(error: Error) {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func successfulLogin() {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            // Present next view controller or use performSegue(withIdentifier:, sender:)
            //self.present(MainViewController(), animated: true, completion: nil)
        }
    }
    
    // MARK: Actions
    
    @objc func spotifySigninAction(_ sender: UIButton) {
        
        // Before presenting the view controllers we are going to start watching for the notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.receievedUrlFromSpotify(_ :)),
                                               name: NSNotification.Name.Spotify.authURLOpened,
                                               object: nil)
        
        //Check to see if the user has Spotify installed
        if SPTAuth.supportsApplicationAuthentication() {
            //Open the Spotify app by opening its url
            UIApplication.shared.open(Spotify().appURL, options: [:], completionHandler: nil)
        } else {
            //Present a web browser in the app that lets the user sign in to Spotify
            safariViewController = SFSafariViewController(url: Spotify().webURL)
            present(safariViewController, animated: true, completion: nil)
        }
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
