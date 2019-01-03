//
//  AppDelegate.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 13/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import netfox_ios


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupSpotify()
        checkSpotifySession()
        AppEngine.setUIElementsAppearances()
        
        NFX.sharedInstance().start()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //Check if this URL was sent from the Spotify app or website
        if SPTAuth.defaultInstance().canHandle(url) {
            //Send out a notification which we can listen for in our sign in view controller
            NotificationCenter.default.post(name: NSNotification.Name.Spotify.authURLOpened, object: url)
            
            return true
        }
        
        return false
    }
    
    func setupSpotify() {
        
        SPTAuth.defaultInstance().clientID                  = Spotify().clientID
        SPTAuth.defaultInstance().redirectURL               = Spotify().redirectURI
        SPTAuth.defaultInstance().sessionUserDefaultsKey    = Spotify().sessionKey
        
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthUserReadTopScope]

        do {
            try SPTAudioStreamingController.sharedInstance().start(withClientId: Spotify().clientID)
        } catch {
            fatalError("Couldn't start Spotify SDK")
        }
    }
    
    func checkSpotifySession() {
        
        let userDefaults = UserDefaults.standard
        
        if let sessionObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionData = sessionObject as! Data
            let session     = NSKeyedUnarchiver.unarchiveObject(with: sessionData) as! SPTSession
            
            if session.isValid() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.window!.rootViewController = tabBarController
            }
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let tabBarController          = window?.rootViewController as? UITabBarController else { return false }
        guard let navigationController      = tabBarController.viewControllers?.first as? UINavigationController else { return false }
        guard let topArtistsViewController  = navigationController.viewControllers.first as? TopArtistsViewController else { return false }
        
        topArtistsViewController.recieveShortcut()
        return true
    }
}

