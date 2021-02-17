//
//  DebatingView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/02.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

class DebatingViewController: UIViewController, NADViewDelegate {

    @IBOutlet weak var contentsViewOutlet: UIView!
    @IBOutlet weak var themeLabelOutlet: UILabel!
    @IBOutlet weak var timerLabelOutlet: UILabel!
    @IBOutlet var imageButtonOutletCollection: [UIButton]!
    @IBOutlet weak var hugeAdLabelOutlet: UILabel!
    
    let notificationCenter = NotificationCenter.default
    
    var numberOfTalkers: Int?
    var numberOfListeners: Int?
    var selectedGenreOfTheme: (String?, Int?)
    var selfMadeTheme: String?
    var theme: String?
    var separatedTheme = [String?]()
    var timer: Timer!
    var time = (5,0,0)
    var numberOfThemes: Int?
    var csvLines = [String]()
    
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
    
    @IBAction func changeThemeButtonAction(_ sender: UIButton) {
        bounching(buttonState: 2, UIButton: sender)
        changeTheme(genreOfTheme: selectedGenreOfTheme.1!)
        time = (5,0,1)
    }
    
    @IBAction func changeTimeButtonAction(_ sender: UIButton) {
        bounching(buttonState: 2, UIButton: sender)
        changeTime(selectedButtonTag: sender.tag)
    }
    
    @IBAction func imageButtonsTouchDownAction(_ sender: UIButton) {
        bounching(buttonState: 0, UIButton: sender)
    }
    
    @IBAction func imageButtonsDragExitAction(_ sender: UIButton) {
        bounching(buttonState: 1, UIButton: sender)
    }
    
    @IBAction func toVotingViewButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toWarning", sender: nil)
    }
    
    @objc func catchNotification(notification: Notification) {
        performSegue(withIdentifier: "toVoting", sender: nil)
    }
    
    func changeTime(selectedButtonTag tag: Int) {
        switch tag {
        case 1: // -1 minute
            if time.0 > 0 {
                time.0 -= 1
            }
        case 2: // +1 minute
            if time.0 < 58 {
                time.0 += 1
            }
        default:
            break
        }
    }
    
    @objc func step() {
        switch time {
        case (0,0,0):
            break
        case (0...60,1...5,0):
            time.1 -= 1
            time.2 = 99
        case (0...60,0,0):
            time.1 = 5
            time.2 = 99
            time.0 -= 1
        default:
            time.2 -= 1
        }
        timerLabelOutlet.text = "\(time.0):\(time.1)\(time.2/10)"
    }
    
    func showTheme(genreOfTheme genre: Int) {
        themeLabelOutlet.text = ""
        
        if genre == 9 {
            theme = selfMadeTheme!
            themeLabelOutlet.text = theme
        }
        else {
            guard let path = Bundle.main.path(forResource: "ThemeList-\(genre)", ofType: "csv") else {
                print("not found")
                return
            }
            
            do {
                let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                csvLines = csvString.components(separatedBy: .newlines)
                csvLines.removeLast()
            }
            
            catch let error as NSError {
                print(error)
                return
            }
            
            numberOfThemes = csvLines.count
            theme = csvLines[Int.random(in: 2...numberOfThemes! - 1)]
            separatedTheme = theme!.components(separatedBy: .whitespaces)
            
            for n in 0...separatedTheme.count - 1 {
                themeLabelOutlet.text!.append(separatedTheme[n]! + "\n")
            }
            
            themeLabelOutlet.text!.removeLast(1)
        }
    }
    
    func changeTheme(genreOfTheme genre: Int) {
        if genre != 9 {
            themeLabelOutlet.text = ""
            theme = csvLines[Int.random(in: 2...numberOfThemes! - 1)]
            separatedTheme = theme!.components(separatedBy: .whitespaces)
            
            for n in 0...separatedTheme.count - 1 {
                themeLabelOutlet.text!.append(separatedTheme[n]! + "\n")
            }
            
            themeLabelOutlet.text!.removeLast(1)
        }
    }
    
    func bounching(buttonState state: Int, UIButton button: UIButton) {
        switch state {
        case 0: // pushed
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {() -> Void in
                button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        case 1: // dragExit
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {() -> Void in
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        case 2: // released
            UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveLinear, animations: {() -> Void in
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        default:
            break
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
        if segue.identifier == "toVoting" {
            let votingVC = segue.destination as! VotingViewController
            
            votingVC.numberOfTalkers = self.numberOfTalkers
            votingVC.numberOfListeners = self.numberOfListeners
            votingVC.selectedGenreOfTheme = self.selectedGenreOfTheme
            votingVC.theme = self.theme
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIApplication.shared.isIdleTimerDisabled = true
        
        timerLabelOutlet.text = "\(time.0):\(time.1)\(time.2/100)"
        showTheme(genreOfTheme: selectedGenreOfTheme.1!)
        
        notificationCenter.addObserver(self, selector: #selector(catchNotification(notification:)), name: .myNotificationName, object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.step), userInfo: nil, repeats: true)
        
        self.view.addSubview(hugeAdView)
        self.view.addSubview(smallAdView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        themeLabelOutlet.font = UIFont(name: "HiraginoSans-W6", size: CGFloat(themeLabelOutlet.bounds.height / 6))
        
        for n in 0...imageButtonOutletCollection.count - 1 {
            imageButtonOutletCollection[n].imageView?.contentMode = .scaleAspectFill
            imageButtonOutletCollection[n].contentHorizontalAlignment = .fill
            imageButtonOutletCollection[n].contentVerticalAlignment = .fill
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let workingTimer = timer {
            workingTimer.invalidate()
        }
    }

}
