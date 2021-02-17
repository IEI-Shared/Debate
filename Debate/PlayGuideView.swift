//
//  PlayGuideView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/02.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit
import NendAd

class PlayGuideViewController: UIViewController, NADViewDelegate {

    @IBOutlet weak var plauGuideTextViewOutlet: UITextView!
    @IBOutlet weak var toSettingViewButtonOutlet: UIButton!
    
    let styleOfTitle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W6", size: 15)!]
    let styleOfText: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W3", size: 13)!]
    let titleString: [String] = ["1．まずは一緒に討論する仲間を集めよう！\n", "\n2．討論するお題のジャンルを選ぼう！\n", "\n3．プレイヤー名を決めよう！\n", "\n4．討論開始！！\n", "\n5．リスナー採点！\n", "\n6．バトロン終了！\n","\n7．プレイのコツ\n"]
    let textString: [[String]] = [["討論者(バトラー)は2〜10人、傍聴者(リスナー)は１〜10人まで同時に遊べるよ\n"], ["選択したジャンルの中からランダムなお題がゲーム開始時に出題されるよ\n", "もしそのお題が気に入らなければお題変更ボタンで変更してね\n", "自分でお題を作成したいときは、ジャンル選択から”自作”を選んでね\n"], ["プレイヤー名入力画面で、それぞれのニックネームをつけよう\n"], ["いよいよ討論を開始しよう！\n", "バトラーは出題されたお題について、自身の意見でバトルし、相手を論破しよう！\n"], ["リスナーはバトラーたちの討論を聞いて、誰の主張が優れていたか投票しよう\n"], ["リスナーの投票結果から勝者が決まるよ\n", "その他の順位や投票結果は”結果詳細”から確認してね\n"],["どのジャンルのお題も、主に2択や大喜利のような形で出題されるよ\n","バトラーは、相手よりもリスナーが納得できる回答を目指そう！また相手の意見に質問・批判をどんどんして、自分の正当性をアピールしよう！\n"]]
    let commentString: [String] = ["\n説明は以上！\nさっそくみんなで\nLet’s バトロン！！！"]
    
    var playGuide = NSMutableAttributedString()
    var styleOfComment: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W7", size: 20)!]
    
    lazy var smallAdView: NADView = {
        let nadView = NADView(isAdjustAdSize: true)!
        nadView.delegate = self
        nadView.setNendID("772f09c5616458758e77f4a0f54609b919853fe2", spotID: "980853")
        nadView.load()
        
        return nadView
    }()
    
    func setPlayGuide() {
        let commentSetting = NSMutableParagraphStyle()
        commentSetting.alignment = .center
        
        styleOfComment.updateValue(commentSetting, forKey: .paragraphStyle)
        
        for m in 0...titleString.count - 1 {
            playGuide.append(NSAttributedString(string: titleString[m], attributes: styleOfTitle))
            
            for n in 0...textString[m].count - 1 {
                playGuide.append(NSAttributedString(string: textString[m][n], attributes: styleOfText))
            }
        }
        
        playGuide.append(NSAttributedString(string: commentString[0], attributes: styleOfComment))
        plauGuideTextViewOutlet.attributedText = playGuide
    }
    
    @IBAction func toSettingViewButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        adView.frame.origin.x = 0
        adView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.frame.width / 6.4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setPlayGuide()
        
        self.view.addSubview(smallAdView)
    }


}
