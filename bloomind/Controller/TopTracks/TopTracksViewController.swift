//
//  TopTracksViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 17/2/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SnapKit

class TopTracksViewController: MainViewController {
    
    // MARK: Variables
    
    var viewModal: TopTracksViewModal!
    
    // MARK: UI Elements
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        //let layout = VegaScrollFlowLayout()
        
        let width   = UIScreen.main.bounds.width / 2 - 32
        let height  = ((UIScreen.main.bounds.width / 2 - 32) + (width / 2.47) )

        layout.sectionInset     = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize         = CGSize(width: width, height: height)
        layout.scrollDirection  = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 50)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let view                = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        view.backgroundColor    = UIColor.groupTableViewBackground
        
        return view
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createModal()
        setup()
        tableViewRegisterCustomCells()

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
    
    // MARK: Setup
    
    private func setup() {
        
        // LNPopupController appaeriance settings
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.popupBar.barTintColor = UIColor.flatWhite()
        navigationController?.popupBar.progressViewStyle = .bottom
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        view.addSubview(collectionView)
        
        layout()
    }
    
    private func layout() {
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    // MARK: Functions
    
    private func createModal() {
        
        if viewModal == nil {
            viewModal = TopTracksViewModal(delegate: self)
        }
        
        viewModal.getShortTermTopTracks()
        viewModal.getMediumTermTopTracks()
        viewModal.getLongTermTopTracks()
    }
    

    /*
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Collection View Extension

extension TopTracksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModal.topTrackData[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopTrackCollectionViewCell", for: indexPath) as! TopTrackCollectionViewCell
        
        guard let data = viewModal.topTrackData[indexPath.section] else { return cell }
        cell.prepareCell(data: data[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView", for: indexPath) as! SectionHeaderCollectionReusableView
            header.setNeedsLayout()
            
            
            
            if viewModal.sectionInfos[indexPath.section].isVisible{
                header.title.text = viewModal.sectionInfos[indexPath.section].title
            } else {
                header.title.text = ""
            }
            
            
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
    
    
    // MARK: Delegates
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
        
        guard let data = viewModal.topTrackData[indexPath.section] else { return }
        
        preparePopupContentController(withTrack: data[indexPath.row])
        playTrack(withID: data[indexPath.row].ID)

    }
    
    
    // MARK: Helpers
    
    func tableViewRegisterCustomCells() {
        
        collectionView.register(TopTrackCollectionViewCell.self, forCellWithReuseIdentifier: "TopTrackCollectionViewCell")
        collectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView")
    }
}



// MARK: - DNZEmptyDataSet Extension

extension TopTracksViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "emptyState")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        return NSAttributedString(
            string: "Wubba Lubba Dub Dub",
            attributes: [
                NSAttributedStringKey.font: UIFont(name: "\(FontFamily.SFUIDisplay.rawValue)-\(FontStyle.Bold.rawValue)", size: 32)!,
                NSAttributedStringKey.foregroundColor: UIColor.flatGrayColorDark()
            ]
        )
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        return NSAttributedString(
            string: "Nobody exists on purpose nobody belongs anywhere everybody's going to die.",
            attributes: [
                NSAttributedStringKey.font: UIFont(name: "\(FontFamily.SFUIDisplay.rawValue)-\(FontStyle.Regular.rawValue)", size: 20)!,
                NSAttributedStringKey.foregroundColor: UIColor.flatGray()
            ]
        )
    }
}

// MARK: - View Modal Delegates

extension TopTracksViewController: TopTracksViewModalDelegate {
    
    func didSuccessGetShortTernTopTrackList() {
        collectionView.reloadData()
    }
    
    func didSuccessGetMediumTernTopTrackList() {
        collectionView.reloadData()
    }
    
    func didSuccessGetLongTernTopTrackList() {
        collectionView.reloadData()
    }
    
    func didFailureBackendRequest(messages: String) {
        
    }
}
