//
//  SettingView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/02.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

class SettingViewController: UIViewController, UITextFieldDelegate, NADViewDelegate {

    @IBOutlet weak var talkerNumberFieldOutlet: UITextField!
    @IBOutlet weak var listenerNumberFieldOutlet: UITextField!
    @IBOutlet var genreOfThemeButtonOutlet: [UIButton]!
    @IBOutlet weak var toInputtingNamesViewButtonOutlet: UIButton!
    
    let genreOfTheme = ["モノ","学校","漫画","生活","スポーツ","シチュエーション","社会","男女","自作"]
    
    var editingTextFieldTag: Int?
    var selectedGenreOfTheme: (String?, Int?)
    var selfMadeTheme: String?
    
    lazy var smallAdView: NADView = {
        let nadView = NADView(isAdjustAdSize: true)!
        nadView.delegate = self
        nadView.load()
        
        return nadView
    }()
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        saveNumberOfPlayers()
    }
    
    @IBAction func genreOfThemeButtonAction(_ sender: UIButton) {
        selectGenreOfTheme(selectedButtonTag: sender.tag)
    }
    
    @IBAction func toInputtingNamesViewButtonAction(_ sender: UIButton) {
        if (talkerNumberFieldOutlet.text!.isEmpty == false) && (listenerNumberFieldOutlet.text!.isEmpty == false) && (selectedGenreOfTheme != (nil,nil)) {
            let numberOfTalkers: String = talkerNumberFieldOutlet.text!
            let numberOfListeners: String = listenerNumberFieldOutlet.text!
            
            defaults.set(numberOfTalkers, forKey: "numberOfTalkers")
            defaults.set(numberOfListeners, forKey: "numberOfListeners")
            performSegue(withIdentifier: "toInputtingNames", sender: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextFieldTag = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveNumberOfPlayers()
    }
    
    func saveNumberOfPlayers() {
        if editingTextFieldTag == talkerNumberFieldOutlet.tag {
            switch talkerNumberFieldOutlet.text {
            case "2","3","4","5","6","7","8","9","10":
                view.endEditing(true)
            default:
                talkerNumberFieldOutlet.text = ""
            }
        }
        else if editingTextFieldTag == listenerNumberFieldOutlet.tag {
            switch listenerNumberFieldOutlet.text {
            case "1","2","3","4","5","6","7","8","9","10":
                view.endEditing(true)
            default:
                listenerNumberFieldOutlet.text = ""
            }
        }
    }
    
    func selectGenreOfTheme(selectedButtonTag tag: Int) {
        for n in 1...9 {
            if n != tag {
                genreOfThemeButtonOutlet[n-1].alpha = 0.6
            }
            else {
                genreOfThemeButtonOutlet[n-1].alpha = 1.0
                selectedGenreOfTheme = (genreOfTheme[n-1], tag)
            }
        }
        
        if tag == 0 {
            for n in 0...8 {
                genreOfThemeButtonOutlet[n].alpha = 0.6
                selectedGenreOfTheme = (nil, nil)
            }
        }
        else if tag == 9 {
            performSegue(withIdentifier: "toCreatingTheme", sender: nil)
        }
        else {
            selfMadeTheme = nil
        }
    }
    
    func viewPreparation() {
        talkerNumberFieldOutlet.delegate = self
        listenerNumberFieldOutlet.delegate = self
        
        guard let talkerNum = defaults.string(forKey: "numberOfTalkers") else {
            return
        }
        
        talkerNumberFieldOutlet.text = talkerNum
        
        guard let listenerNum = defaults.string(forKey: "numberOfListeners") else {
            return
        }
        
        listenerNumberFieldOutlet.text = listenerNum
    }
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        adView.frame.origin.x = 0
        adView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.frame.width / 6.4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInputtingNames" {
            let inputtingNamesVC = segue.destination as! InputtingNamesViewController
            
            inputtingNamesVC.numberOfTalkers = Int(talkerNumberFieldOutlet.text!)
            inputtingNamesVC.numberOfListeners = Int(listenerNumberFieldOutlet.text!)
            inputtingNamesVC.selectedGenreOfTheme = self.selectedGenreOfTheme
            inputtingNamesVC.selfMadeTheme = self.selfMadeTheme
        }
        else if segue.identifier == "toCreatingTheme" {
            let creatingThemeVC = segue.destination as! CreatingThemeViewController
            
            creatingThemeVC.selfMadeTheme = self.selfMadeTheme
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPreparation()
        
        self.view.addSubview(smallAdView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        for n in 0...8 {
            genreOfThemeButtonOutlet[n].setTitle(genreOfTheme[n], for: .normal)
            genreOfThemeButtonOutlet[n].titleLabel!.adjustsFontSizeToFitWidth = true
        }
    }


}
