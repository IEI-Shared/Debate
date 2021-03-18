//
//  DetailedResultView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/02.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

class DetailedResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NADViewDelegate {
    
    @IBOutlet weak var detailedResultTableViewOutlet: UITableView!
    
    var numberOfTalkers: Int?
    var numberOfListeners: Int?
    var selectedGenreOfTheme: (String?, Int?)
    var theme: String?
    var totalVote = [[Int?]]()
    var nameAndVotesOfTalkers = [(String?, Int?)]()
    
    lazy var smallAdView: NADView = {
        let nadView = NADView(isAdjustAdSize: true)!
        nadView.delegate = self
        nadView.load()
        
        return nadView
    }()
    
    @IBAction func toResultViewButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
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
            headerLabel.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.863, alpha: 1.0)
            headerLabel.text = "集計結果"
        default:
            headerLabel.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.863, alpha: 1.0)
            headerLabel.text = "投票詳細"
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
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell-1", for: indexPath) as! VotesCell
            
            tableView.rowHeight = 75
            cell.nameOfTalkersLabelOutlet.text = nameAndVotesOfTalkers[indexPath.row].0!
            cell.votesLabelOutlet.text = String(nameAndVotesOfTalkers[indexPath.row].1!) + "票"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell-2", for: indexPath) as! VotingDetailsCell
            
            tableView.rowHeight = 200
            
            if (defaults.object(forKey: players[1][indexPath.row]) != nil) && (defaults.string(forKey: players[1][indexPath.row])!.isEmpty == false) {
                cell.nameOfListenersLabelOutlet.text = defaults.string(forKey: players[1][indexPath.row])
            }
            else {
                cell.nameOfListenersLabelOutlet.text = "リスナー\(indexPath.row + 1)"
            }
            
            for n in 0...3 {
                if totalVote[indexPath.row][n] != nil {
                    if (defaults.object(forKey: players[0][totalVote[indexPath.row][n]!]) != nil) && (defaults.string(forKey: players[0][totalVote[indexPath.row][n]!])!.isEmpty == false) {
                        cell.nameOfTalkersLabelOutletCollection[n].text = defaults.string(forKey: players[0][totalVote[indexPath.row][n]!])
                    }
                    else {
                        cell.nameOfTalkersLabelOutletCollection[n].text = "バトラー\(totalVote[indexPath.row][n]! + 1)"
                    }
                }
                else {
                    cell.nameOfTalkersLabelOutletCollection[n].text = ""
                }
            }
            
            return cell
        }
    }
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        adView.frame.origin.x = 0
        adView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.frame.width / 6.4
    }
    
    func viewPreparation() {
        detailedResultTableViewOutlet.register(UINib(nibName: "VotesCell", bundle: nil), forCellReuseIdentifier: "customCell-1")
        detailedResultTableViewOutlet.register(UINib(nibName: "VotingDetailsCell", bundle: nil), forCellReuseIdentifier: "customCell-2")
        
        detailedResultTableViewOutlet.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPreparation()
        
        self.view.addSubview(smallAdView)
    }


}
