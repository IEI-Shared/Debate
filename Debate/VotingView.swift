//
//  VotingView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/02.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

class VotingViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NADViewDelegate {

    @IBOutlet weak var nameOfListenersLabelOutlet: UILabel!
    @IBOutlet var votingForNameTextFieldOutletCollection: [UITextField]!
    @IBOutlet weak var toResultViewButtonOutlet: UIButton!
    @IBOutlet weak var toResultViewLabelOutlet: UILabel!
    
    var numberOfTalkers: Int?
    var nameAndVotesOfTalkers = [(String?, Int?)]()
    var numberOfListeners: Int?
    var remainingNumberOfListener: Int!
    var selectedGenreOfTheme: (String?, Int?)
    var theme: String?
    var editingTextFieldTag: Int?
    var votingPickerView: UIPickerView = UIPickerView()
    var totalVote = [[Int?]]()
    var votes: [Int?] = [nil, nil, nil, nil]
    
    lazy var smallAdView: NADView = {
        let nadView = NADView(isAdjustAdSize: true)!
        nadView.delegate = self
        nadView.setNendID("772f09c5616458758e77f4a0f54609b919853fe2", spotID: "980853")
        nadView.load()
        
        return nadView
    }()
    
    @IBAction func toResultViewButtonAction(_ sender: UIButton) {
        toNextListener()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextFieldTag = textField.tag
        textField.text = ""
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingTextFieldTag = nil
        votingPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfTalkers! + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "---選択してください---"
        default:
            return nameAndVotesOfTalkers[row - 1].0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            break
        default:
            self.votingForNameTextFieldOutletCollection[editingTextFieldTag! - 1].text = nameAndVotesOfTalkers[row - 1].0
            votes[editingTextFieldTag! - 1] = row - 1
        }
    }
    
    @objc func cancel() {
        self.votingForNameTextFieldOutletCollection[editingTextFieldTag! - 1].text = ""
        votes[editingTextFieldTag! - 1] = nil
        self.votingForNameTextFieldOutletCollection[editingTextFieldTag! - 1].endEditing(true)
    }
    
    @objc func done() {
        self.votingForNameTextFieldOutletCollection[editingTextFieldTag! - 1].endEditing(true)
    }
    
    func makePickerView() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        
        toolBar.setItems([cancelItem, doneItem], animated: true)
        
        for n in 0...3 {
            votingForNameTextFieldOutletCollection[n].inputView = votingPickerView
            votingForNameTextFieldOutletCollection[n].inputAccessoryView = toolBar
        }
    }
    
    func toNextListener() {
        remainingNumberOfListener -= 1
        totalVote.append(votes)
        
        switch remainingNumberOfListener {
        case 0:
            performSegue(withIdentifier: "toResult", sender: nil)
        case 1:
            toResultViewLabelOutlet.text = "結果発表"
            toResultViewButtonOutlet.setImage(UIImage(named: "RedTag"), for: .normal)
            fallthrough
        default:
            for n in 0...3 {
            votingForNameTextFieldOutletCollection[n].text = ""
            votes[n] = nil
            }
            
            if (defaults.object(forKey: players[1][numberOfListeners! - remainingNumberOfListener]) != nil) && (defaults.string(forKey: players[1][numberOfListeners! - remainingNumberOfListener])!.isEmpty == false) {
                nameOfListenersLabelOutlet.text = defaults.string(forKey: players[1][numberOfListeners! - remainingNumberOfListener])
            }
            else {
                nameOfListenersLabelOutlet.text = "リスナー\(numberOfListeners! - remainingNumberOfListener + 1)"
            }
        }
    }
    
    func viewPreparation() {
        // delegateの設定
        for n in 0...3 {
            votingForNameTextFieldOutletCollection[n].delegate = self
        }
        
        votingPickerView.delegate = self
        votingPickerView.dataSource = self
        
        // リスナーの名前をラベルに
        if (defaults.object(forKey: players[1][0]) != nil) && (defaults.string(forKey: players[1][0])!.isEmpty == false) {
            nameOfListenersLabelOutlet.text = defaults.string(forKey: players[1][0])
        }
        else {
            nameOfListenersLabelOutlet.text = "リスナー1"
        }
        
        // 投票していないリスナーの数を決定
        remainingNumberOfListener = numberOfListeners!
        
        if remainingNumberOfListener == 1 {
            toResultViewLabelOutlet.text = "結果発表"
            toResultViewButtonOutlet.setImage(UIImage(named: "RedTag"), for: .normal)
        }
        
        // バトラーの名前をnameAndVotesOfTalkersの配列に代入
        for n in 0...numberOfTalkers! - 1 {
            if (defaults.object(forKey: players[0][n]) != nil) && (defaults.string(forKey: players[0][n])!.isEmpty == false) {
                nameAndVotesOfTalkers.append((defaults.string(forKey: players[0][n])!, 0))
            }
            else {
                nameAndVotesOfTalkers.append(("バトラー\(n + 1)", 0))
            }
        }
        
        makePickerView()
    }
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        adView.frame.origin.x = 0
        adView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.frame.width / 6.4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultViewController
        
        resultVC.numberOfTalkers = self.numberOfTalkers
        resultVC.nameAndVotesOfTalkers = self.nameAndVotesOfTalkers
        resultVC.numberOfListeners = self.numberOfListeners
        resultVC.selectedGenreOfTheme = self.selectedGenreOfTheme
        resultVC.theme = self.theme
        resultVC.totalVote = self.totalVote
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPreparation()
        
        self.view.addSubview(smallAdView)
    }


}
