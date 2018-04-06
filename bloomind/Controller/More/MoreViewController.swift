//
//  MoreViewController.swift
//  bloomind
//
//  Created by Niyazi Tanyeri on 3/3/18.
//  Copyright © 2018 Niyazi Tanyeri. All rights reserved.
//

import UIKit
import Chameleon
import Kingfisher
import StoreKit

class MoreViewController: UIViewController {

    // MARK: Variables
    
    var viewModal: MoreViewModal!

    // MARK: UI Elements
    
    lazy var userProfileContainerImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = HexColor("F4B93E")
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var displayName: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Bold, size: 36, color: UIColor.flatWhite())
        label.textAlignment = .left
        return label
    }()
    
    lazy var tableView: UITableView = {
       let view = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        view.dataSource = self
        view.delegate = self
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.text = "\"Without music life would be a mistake.\""
        label.textAlignment = .center
        label.setFontWithColor(FontFamily.SFUIDisplay, style: FontStyle.Regular, size: 12, color: UIColor.flatYellow())
        view.tableFooterView = label
        return view
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createModal()
        tableViewRegisterCustomCells()
        setup()
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


extension MoreViewController {
    
    // MARK: Functions
    
    func setup() {
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(tableView)
        view.addSubview(userProfileContainerImageView)
        view.addSubview(displayName)
        layout()
        
    }
    
    func layout() {
        
        userProfileContainerImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(170)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(userProfileContainerImageView.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(0)
        }
        
        displayName.snp.makeConstraints { (make) in
            make.centerX.equalTo(userProfileContainerImageView)
            make.height.equalTo(40)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.bottom.equalTo(userProfileContainerImageView.snp.bottom).offset(-20)
        }
    }
    
    func createModal() {
        
        if viewModal == nil {
            viewModal = MoreViewModal(delegate: self)
        }
        
        viewModal.getSPTUserInfo()
    }
    
    func share(message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func showSingoutDialog() {
        
        let alertController = UIAlertController(title: "Signout", message: "Are you sure you want to sign out", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
        }
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.signoutAction()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signoutAction() {
        self.viewModal.removeSession()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showStreamingQualityPicker() {
        
        let alert = UIAlertController(style: .actionSheet, title: "Streaming Quality", message: "Please select targeted streaming quality.")
        
        let selectedValue = SPTAudioStreamingController.sharedInstance().targetBitrate.rawValue
        
        let pickerViewValues: [[String]] = [["~96kbit/sec", "~160kbit/sec", "~320kbit/sec"]]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: Int(selectedValue))
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            
            SPTAudioStreamingController.sharedInstance().setTargetBitrate(SPTBitrate(rawValue: UInt(index.row))!, callback: { (error) in
                self.tableView.reloadData()
            })
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    func showCountryPicker() {
        
        let alert = UIAlertController(style: .actionSheet,
                                      message: "Select Country")
        alert.addLocalePicker(type: .country) { info in
            
            guard let data = info else { return }
            self.viewModal.changeRegionWith(regionCode: data.code)
            self.tableView.reloadData()
            //tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: UITableViewRowAnimation.automatic)
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
}

extension MoreViewController: UIScrollViewDelegate {
    
    func animateHeader() {
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let height = 170 + (-scrollView.contentOffset.y)
//        if height > 170 {
//            self.userProfileContainerImageView.snp.updateConstraints({ (update) in
//                update.height.equalTo(170 + (-scrollView.contentOffset.y))
//            })
//        }
        //self.view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    

}


// MARK: Table View Extension

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: DataSoure
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.tableViewData[section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as UITableViewCell
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        }
        
        cell!.textLabel?.text = viewModal.tableViewData[indexPath.section]![indexPath.row]
        
        switch (indexPath.section, indexPath.row) {
        case(0,0):
            cell?.detailTextLabel?.text = Bitrate(rawValue: SPTAudioStreamingController.sharedInstance().targetBitrate.rawValue)?.displayValue
        case(0,1):
            cell?.detailTextLabel?.text = viewModal.getRegionOfUser() ?? "Select"
        case (2,0):
            cell!.detailTextLabel?.text = AppEngine.getVersionNumber()
        case (2,1):
            cell!.detailTextLabel?.text = AppEngine.getBuildNumber()
        default:
            break
        }

        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "Copyright © 2018 Niyazi Tanyeri. All rights reserved."
        }
        else if section == 0 {
            return "*top songs of artists ordered by region"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            cell.textLabel?.textColor = UIColor.flatRed()
        }
    }
    
    // MARK: Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            showStreamingQualityPicker()
        case (0,1):
            showCountryPicker()
        case (1,0):
            SKStoreReviewController.requestReview()
        case (1,1):
            share(message: "Songspire: Spotify Analyzer", link: "http://www.google.com")
        case (3,0):
            showSingoutDialog()
        default:
            break
        }
    }
    
    
    // MARK: Helpers
    
    func tableViewRegisterCustomCells() {

    }
}


// MARK: View Modal Delegates

extension MoreViewController: MoreViewModalDelegate {

    func didSuccessUserInfoRequest() {
        tableView.reloadData()
        
        let processor = BlurImageProcessor(blurRadius: 4)
        
        displayName.text = viewModal.userInfo!.displayName
        userProfileContainerImageView.kf.setImage(with: viewModal.userInfo!.largestImage.imageURL,
                                                            placeholder: nil,
                                                            options: [.processor(processor)],
                                                            progressBlock: nil,
                                                            completionHandler: nil)
        
        
    }
    
    func didFailureUserInfoRequest(messages: String?) {
        
    }
}
