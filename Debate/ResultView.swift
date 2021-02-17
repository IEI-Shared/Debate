//
//  ResultView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/02.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

class ResultViewController: UIViewController, NADViewDelegate {

    @IBOutlet weak var contentsViewOutlet: UIView!
    @IBOutlet weak var numberOfWinnerLabelOutlet: UILabel!
    @IBOutlet weak var nameOfWinnersLabelOutlet: UILabel!
    @IBOutlet weak var hugeAdLabelOutlet: UILabel!
    
    var numberOfTalkers: Int?
    var numberOfListeners: Int?
    var selectedGenreOfTheme: (String?, Int?)
    var theme: String?
    var totalVote = [[Int?]]()
    var nameAndVotesOfTalkers = [(String?, Int?)]()
    
    lazy var hugeAdView: NADView = {
        let nadView = NADView()
        nadView.delegate = self
        nadView.setNendID("9d447ab90ba843c04a538f5807c944764b5da721", spotID: "980854")
        nadView.load()
        
        return nadView
    }()
    lazy var smallAdView: NADView = {
        let nadView = NADView(isAdjustAdSize: true)!
        nadView.delegate = self
        nadView.setNendID("772f09c5616458758e77f4a0f54609b919853fe2", spotID: "980853")
        nadView.load()
        
        return nadView
    }()
    
    @IBAction func toDetailedResultViewButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toDetailedResult", sender: nil)
    }
    
    @IBAction func toSettingViewButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    func aggregateTotalVotes() {
        for m in 0...numberOfListeners! - 1 {
            for n in 0...3 {
                if totalVote[m][n] != nil {
                    nameAndVotesOfTalkers[totalVote[m][n]!].1! += 1
                }
            }
        }
    }
    
    func viewPreparation() {
        aggregateTotalVotes()
        nameAndVotesOfTalkers.sort(by: {$1.1! < $0.1!})
        
        let maximumPoint: Int = nameAndVotesOfTalkers[0].1!
        var winners = [String?]()
        var numberOfWinners: Int = 0
        
        for n in 0...numberOfTalkers! - 1 {
            if nameAndVotesOfTalkers[n].1! == maximumPoint {
                winners.append(nameAndVotesOfTalkers[n].0!)
                numberOfWinners += 1
            }
        }
        
        if numberOfWinners == 1 {
            numberOfWinnerLabelOutlet.text = "WINNER"
            nameOfWinnersLabelOutlet.text = nameAndVotesOfTalkers[0].0!
        }
        else if numberOfWinners == nameAndVotesOfTalkers.count {
            numberOfWinnerLabelOutlet.text = "NO WINNER"
            nameOfWinnersLabelOutlet.text = "NO WINNER"
        }
        else {
            numberOfWinnerLabelOutlet.text = "WINNERS"
            nameOfWinnersLabelOutlet.text = ""
            
            for n in 0...numberOfWinners - 1 {
                nameOfWinnersLabelOutlet.text!.append(contentsOf: winners[n]! + ",")
            }
            
            nameOfWinnersLabelOutlet.text!.removeLast()
        }
    }
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        if adView == smallAdView {
            adView.frame.origin.x = 0
            adView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.frame.width / 6.4
        }
        else if adView == hugeAdView {
            adView.frame.origin = self.view.convert(self.hugeAdLabelOutlet.frame.origin, from: self.contentsViewOutlet)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedResult" {
            let detailedResultVC = segue.destination as! DetailedResultViewController
            
            detailedResultVC.numberOfTalkers = self.numberOfTalkers
            detailedResultVC.numberOfListeners = self.numberOfListeners
            detailedResultVC.selectedGenreOfTheme = self.selectedGenreOfTheme
            detailedResultVC.theme = self.theme
            detailedResultVC.totalVote = self.totalVote
            detailedResultVC.nameAndVotesOfTalkers = self.nameAndVotesOfTalkers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPreparation()
        
        self.view.addSubview(hugeAdView)
        self.view.addSubview(smallAdView)
    }


}
