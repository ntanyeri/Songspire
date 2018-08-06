//
//  ArtistDetailViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 6/3/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import Chameleon

class ArtistDetailViewController: MainViewController {
    
    // MARK: Variables
    
    var viewModal: ArtistDetailViewModal!
    
    
    // MARK: UI Elements
    
    lazy var artistImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.kf.setImage(with: viewModal?.artistData.image)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = viewModal?.artistData.name
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Bold, size: 36, color: UIColor.flatBlack())
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
        button.setTitle(" Back", for: .normal)
        button.tintColor = UIColor.white
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(self.returnBackAction(_:)), for: .touchUpInside)
        return button
    }()

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        tableViewRegisterCustomCells()
        
        if viewModal != nil {
            viewModal!.delegate = self
            viewModal?.getTopTracks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension ArtistDetailViewController {
    
    // MARK: Setup
    
    private func setup() {
        
        AppEngine.addImageOverlay(frame: artistImageView.frame, alpha: 0.2, toView: artistImageView)
        
        view.addSubview(artistImageView)
        view.addSubview(artistNameLabel)
        view.addSubview(tableView)
        view.addSubview(backButton)
        
        layout()
    }
    
    private func layout() {
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(15)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }

        artistImageView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(0)
            make.height.equalTo(200)
        }
        
        artistNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistImageView.snp.bottom).offset(18)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(37)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(8)
            make.bottom.left.right.equalTo(0)
        }
    }
    
    
    // MARK: Actions
    
    @objc func returnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ArtistDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal?.topTracks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTopSongTableViewCell", for: indexPath) as! ArtistTopSongTableViewCell
        
        cell.prepareCell(data: viewModal!.topTracks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top Songs"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.backgroundView?.backgroundColor = UIColor.white
        
        if let textlabel = header.textLabel {
            textlabel.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Bold, size: 26, color: UIColor.flatBlack())
        }
    }
    
    // MARK: Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
        
        preparePopupContentController(withTrack: viewModal.topTracks[indexPath.row])
        playTrack(withID: viewModal.topTracks[indexPath.row].ID)
    }
    
    // MARK: Helpers
    
    func tableViewRegisterCustomCells() {
        
        self.tableView.register(ArtistTopSongTableViewCell.self, forCellReuseIdentifier: "ArtistTopSongTableViewCell")
    }
}

extension ArtistDetailViewController: ArtistDetailViewModalDeletage {
    
    func didSuccessGetTopTracksList() {
        tableView.reloadData()
    }
    
    func didFailureBackendRequest(messages: String) {
        
        
    }
}
