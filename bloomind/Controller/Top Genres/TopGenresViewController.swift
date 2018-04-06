//
//  TopGenresViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 5/3/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import Magnetic
import Chameleon

class TopGenresViewController: UIViewController {
    
    var magnetic: Magnetic?
    var genres = [Genre]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = self.tabBarController {
            if let viewControllers = tabBarController.viewControllers {
                if let first = viewControllers.first {
                    let navigationController = first as! UINavigationController
                    let topArtistsViewController = navigationController.viewControllers.first as! TopArtistsViewController
                    
                    guard let shortTermTopArtistData = topArtistsViewController.viewModal.topArtistData[0] else { return }
                    for shortTermList in shortTermTopArtistData{
                        if let genreList = shortTermList.genres {
                            for genre in genreList {
                                if genres.contains(where: { $0.name == genre.name }) {
                                    genres.filter({ $0.name == genre.name}).first?.reputaion += 1
                                    // found
                                } else {
                                    self.genres.append(genre)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        addMagneticView()
        
        for genre in genres {
            let node = Node(text: genre.name, image: nil, color: UIColor.init(randomColorIn: [UIColor(hexString: "54C7FC"), UIColor(hexString: "FFCD00"), UIColor(hexString: "FF9600"), UIColor(hexString: "FF2851"), UIColor(hexString: "0076FF"), UIColor(hexString: "44DB5E"), UIColor(hexString: "FF3824"), UIColor(hexString: "8E8E93")]), radius: CGFloat((genre.reputaion * 12) + 25))
            magnetic!.addChild(node)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    func prepareGenreData(genderArray: [Genre]) {
        
        
    }
    
    func addMagneticView() {
        
        let magneticView = MagneticView(frame: self.view.bounds)
        magnetic = magneticView.magnetic
        self.view.addSubview(magneticView)
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
