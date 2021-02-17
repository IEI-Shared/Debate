//
//  TitleView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/02.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

let defaults = UserDefaults.standard
let players = [["talker1","talker2","talker3","talker4","talker5","talker6","talker7","talker8","talker9","talker10"],["listener1","listener2","listener3","listener4","listener5","listener6","listener7","listener8","listener9","listener10"]]

class TitleViewController: UIViewController, NADViewDelegate {

    @IBOutlet var imageViewOutletCollection: [UIImageView]!
    @IBOutlet weak var contentViewOutlet: UIView!
    @IBOutlet weak var toSettingViewButtonOutlet: UIButton!
    @IBOutlet weak var toPlayGuideViewButtonOutlet: UIButton!
    
    lazy var smallAdView: NADView = {
        let nadView = NADView(isAdjustAdSize: true)!
        nadView.delegate = self
        nadView.setNendID("772f09c5616458758e77f4a0f54609b919853fe2", spotID: "980853")
        nadView.load()
        
        return nadView
    }()
    
    @IBAction func toSettingViewButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    @IBAction func toPlayGuideViewButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toPlayGuide", sender: nil)
    }
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        adView.frame.origin.x = 0
        adView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.frame.width / 6.4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.contentViewOutlet.alpha = 0.0
        for n in 0...imageViewOutletCollection.count - 1 {
            imageViewOutletCollection[n].alpha = 0
        }
        
        self.view.addSubview(smallAdView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {() -> Void in
            self.contentViewOutlet.alpha = 1.0
            for n in 0...self.imageViewOutletCollection.count - 1 {
                self.imageViewOutletCollection[n].alpha = 1.0
            }
        }, completion: nil)
    }


}
