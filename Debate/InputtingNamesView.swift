//
//  InputtingNamesView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/03.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

class InputtingNamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NADViewDelegate {

    @IBOutlet weak var backViewButtonOutlet: UIButton!
    @IBOutlet weak var inputtingNamesTableOutlet: UITableView!
    
//    let notification = NotificationCenter.default
    
    var numberOfTalkers: Int?
    var numberOfListeners: Int?
    var selectedGenreOfTheme: (String?, Int?)
    var selfMadeTheme: String?
    var editingTextField: UITextField?
    
    lazy var smallAdView: NADView = {
        let nadView = NADView(isAdjustAdSize: true)!
        nadView.delegate = self
        nadView.setNendID("772f09c5616458758e77f4a0f54609b919853fe2", spotID: "980853")
        nadView.load()
        
        return nadView
    }()
    
    @IBAction func backViewButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func toDebatingViewButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toDebating", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 40.0))
        
        headerLabel.font = UIFont(name: "HiraginoSans-W6", size: 28.0)
        headerLabel.textAlignment = .center
        
        switch section {
        case 0:
            headerLabel.backgroundColor = UIColor(red: 0.902, green: 0.902, blue: 0.980, alpha: 1.0)
            headerLabel.text = "バトラー"
        default:
            headerLabel.backgroundColor = UIColor(red: 0.902, green: 0.902, blue: 0.980, alpha: 1.0)
            headerLabel.text = "リスナー"
        }
        
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 10.0))
        
        footerLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        return footerLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return numberOfTalkers!
        case 1:
            return numberOfListeners!
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! InputtingNamesCell
        
        cell.clearButtonOutlet.titleLabel!.adjustsFontSizeToFitWidth = true
        cell.clearButtonOutlet.layer.cornerRadius = 5.0
        cell.clearButtonOutlet.tag = indexPath.section * 10 + indexPath.row
        cell.clearButtonOutlet.backgroundColor = UIColor(red: 0.863, green: 0.863, blue: 0.863, alpha: 1.0)
        cell.nameOfPlayersField.delegate = self
        cell.nameOfPlayersField.tag = indexPath.section * 10 + indexPath.row
        
        if (defaults.object(forKey: players[indexPath.section][indexPath.row]) != nil) && (defaults.string(forKey: players[indexPath.section][indexPath.row])!.isEmpty == false) {
            cell.nameOfPlayersField.text = defaults.string(forKey: players[indexPath.section][indexPath.row])
        }
//        else {
//            switch indexPath.section {
//            case 0:
//                cell.nameOfPlayersField.text = "バトラー\(indexPath.row+1)"
//            case 1:
//                cell.nameOfPlayersField.text = "リスナー\(indexPath.row+1)"
//            default:
//                break
//            }
//        }
        
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
        
        switch textField.tag/10 {
        case 0:
            defaults.removeObject(forKey: players[0][textField.tag])
        case 1:
            defaults.removeObject(forKey: players[1][textField.tag-10])
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let maxLength: Int = 10
        
        guard let text = textField.text else {
            return
        }
        
        editingTextField = nil
        textField.text = String(text.prefix(maxLength))
        
        switch textField.tag/10 {
        case 0:
            if textField.text!.isEmpty == false {
                defaults.set(textField.text!, forKey: players[0][textField.tag])
            }
        case 1:
            if textField.text!.isEmpty == false {
                defaults.set(textField.text!, forKey: players[1][textField.tag-10])
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    @objc func keyboardChangeFrame(_ notification: Notification) {
//
//        guard let fld = editingTextField else {
//            return
//        }
//
//        let userInfo = (notification as NSNotification).userInfo!
//        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let fldFrame = view.convert(fld.frame, from: inputtingNamesTableOutlet)
//
//        overlap = fldFrame.maxY - keyboardFrame.minY + 10
//
//        print(fldFrame.maxY, keyboardFrame.minY, overlap)
//    }
//
//    @objc func keyboardDidShow(_ notification: Notification) {
//        lastOffsetY = inputtingNamesTableOutlet.contentOffset.y
//
//        if overlap > 0 {
//            overlap += inputtingNamesTableOutlet.contentOffset.y
//            inputtingNamesTableOutlet.setContentOffset(CGPoint(x: 0, y: overlap), animated: true)
//        }
//    }
//
//    @objc func keyboardDidHide(_ notification: Notification) {
//        inputtingNamesTableOutlet.setContentOffset(CGPoint(x: 0, y: lastOffsetY), animated: true)
//    }
    
    func viewPreparation() {
        backViewButtonOutlet.imageView!.contentMode = .scaleAspectFill
        backViewButtonOutlet.contentVerticalAlignment = .fill
        backViewButtonOutlet.contentHorizontalAlignment = .fill
        
        inputtingNamesTableOutlet.register(UINib(nibName: "InputtingNamesCell", bundle: nil), forCellReuseIdentifier: "customCell")
        inputtingNamesTableOutlet.rowHeight = 50
        inputtingNamesTableOutlet.tableFooterView = UIView()
        inputtingNamesTableOutlet.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
//        notification.addObserver(self, selector: #selector(self.keyboardChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
//
//        notification.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//
//        notification.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        adView.frame.origin.x = 0
        adView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.frame.width / 6.4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let debatingVC = segue.destination as! DebatingViewController
        
        debatingVC.numberOfTalkers = self.numberOfTalkers
        debatingVC.numberOfListeners = self.numberOfListeners
        debatingVC.selectedGenreOfTheme = self.selectedGenreOfTheme
        debatingVC.selfMadeTheme = self.selfMadeTheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPreparation()
        
        self.view.addSubview(smallAdView)
    }


}
