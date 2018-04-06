//
//  TopArtistsViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TopArtistsViewController: UIViewController {

    // MARK: Variables
    
    var viewModal: TopArtistsViewModal!
    var player: SPTAudioStreamingController?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createModal()
        tableViewRegisterCustomCells()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = true

    }
    

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ArtistDetailViewController" {
            
            //let navigationController = segue.destination as! UINavigationController
            let destinationViewController = segue.destination as! ArtistDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let data = viewModal.topArtistData[indexPath.section]![indexPath.row]
                destinationViewController.viewModal = ArtistDetailViewModal(withData: data)
            }
        }
    }

}

// MARK: - ViewController Extension

extension TopArtistsViewController {
    
    // MARK: Functions
    
    func createModal() {
        
        if viewModal == nil {
            viewModal = TopArtistsViewModal(delegate: self)
        }
        
        viewModal.getShortTermTopArtist()
        viewModal.getMediumTermTopArtist()
        viewModal.getLongTermTopArtist()
    }
}


// MARK: - UITableView Extension

extension TopArtistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModal.topArtistData[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopArtistTableViewCell", for: indexPath) as! TopArtistTableViewCell
        
        if let data = viewModal.topArtistData[indexPath.section] {
            cell.prepareCell(data: data[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if viewModal.sectionInfos[section].isVisible{
            return viewModal.sectionInfos[section].title
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModal.sectionInfos[section].isVisible {
            return UITableViewAutomaticDimension
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        if let textlabel = header.textLabel {
            textlabel.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Medium, size: 15, color: .flatGrayColorDark())
        }
    }
    
    // MARK: Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ArtistDetailViewController", sender: self)
    }
    
    // MARK: Helpers
    
    func tableViewRegisterCustomCells() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.register(TopArtistTableViewCell.self, forCellReuseIdentifier: "TopArtistTableViewCell")
    }
}

// MARK: - DNZEmptyDataSet Extension

extension TopArtistsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: Data Source
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "emptyState")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        tableView.contentInset = UIEdgeInsets.zero
        
        return NSAttributedString(
            string: "Take Us Your Leader",
            attributes: [
                NSAttributedStringKey.font: UIFont(name: "\(FontFamily.SFUIDisplay.rawValue)-\(FontStyle.Bold.rawValue)", size: 32)!,
                NSAttributedStringKey.foregroundColor: UIColor.flatGrayColorDark()
            ]
        )
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        return NSAttributedString(
            string: "Only if you promise to take him back with you",
            attributes: [
                NSAttributedStringKey.font: UIFont(name: "\(FontFamily.SFUIDisplay.rawValue)-\(FontStyle.Regular.rawValue)", size: 20)!,
                NSAttributedStringKey.foregroundColor: UIColor.flatGray()
            ]
        )
    }
}

// MARK: - View Modal Extension

extension TopArtistsViewController: TopArtistsViewModalDelegate {
    
    // MARK: Delegates
    
    func didSuccessGetLongTernTopArtistList() {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
    }
    
    func didSuccessGetMediumTernTopArtistList() {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
    }
    
    func didSuccessGetShortTernTopArtistList() {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
    }
    
    func didFailureBackendRequest(messages: String) {
        
    }
}


// MARK: - UIScrollView Extension

extension TopArtistsViewController: UIScrollViewDelegate {

    // MARK: Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for cell in self.tableView.visibleCells as! [TopArtistTableViewCell] {
            let x = cell.artistImageView.frame.origin.x
            let w = cell.artistImageView.bounds.width
            let h = cell.artistImageView.bounds.height
            let y = ((tableView.contentOffset.y - cell.frame.origin.y) / h) * 25
            cell.artistImageView.frame = CGRect(x: x, y: y, width: w, height: h)
        }

        self.view.layoutIfNeeded()
    }
    
}

