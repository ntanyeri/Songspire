//
//  Router.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import Foundation


class Router {
    
    class func pushHomeViewController(target: UIViewController) {
        
        let storyboard          = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController    = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController

        //target.navigationController?.pushViewController(tabBarController, animated: true)
        
        target.present(tabBarController, animated: true, completion: nil)
    }
}
