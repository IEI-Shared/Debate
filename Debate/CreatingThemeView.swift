//
//  CreatingThemeView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/05.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit

class CreatingThemeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contentViewOutlet: UIView!
    @IBOutlet weak var creatingThemeTextViewOutlet: UITextView!
    @IBOutlet weak var cancelCreatingThemeButtonOutlet: UIButton!
    @IBOutlet weak var finishCreatingThemeButtonOutlet: UIButton!
    
    let suggestion: String = "お題を入力してください"
    let notification = NotificationCenter.default
    
    var selfMadeTheme: String?
    var overlap: CGFloat = 0.0
    var contentOrigin: CGPoint?
    
    @IBAction func creatingThemeButtonAction(_ sender: UIButton) {
        toSettingView(selectedButtonTag: sender.tag)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == suggestion {
            textView.textColor = UIColor.darkText
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func keyboardChangeFrame(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        overlap = contentViewOutlet.frame.maxY - keyboardFrame.minY + 5
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if overlap > 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {() -> Void in
                self.contentViewOutlet.frame.origin = CGPoint(x: self.contentOrigin!.x , y: self.contentOrigin!.y - self.overlap)
            }, completion: nil)
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {() -> Void in
            self.contentViewOutlet.frame.origin = CGPoint(x: self.contentOrigin!.x , y: self.contentOrigin!.y)
        }, completion: nil)
    }
    
    func toSettingView(selectedButtonTag tag: Int) {
        let settingVC = self.presentingViewController as! SettingViewController
        
        switch tag {
        case 1: // cancel
            if settingVC.selfMadeTheme == nil {
                settingVC.selectGenreOfTheme(selectedButtonTag: 0)
            }
            bouncingView(caseNumber: 1)
        case 2: // finish
            if (creatingThemeTextViewOutlet.text.isEmpty) || (creatingThemeTextViewOutlet.text == suggestion) {
                creatingThemeTextViewOutlet.resignFirstResponder()
                creatingThemeTextViewOutlet.textColor = UIColor.gray
                creatingThemeTextViewOutlet.text = suggestion
                
            }
            else {
                settingVC.selfMadeTheme = creatingThemeTextViewOutlet.text
                bouncingView(caseNumber: 1)
            }
        default:
            break
        }
    }
    
    func bouncingView(caseNumber number: Int) {
        switch number {
        case 0:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveLinear, animations: {() -> Void in
                self.contentViewOutlet.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        case 1:
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.contentViewOutlet.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: {(bool) -> Void in
                self.dismiss(animated: false, completion: nil)
            })
        default:
            break
        }
    }
    
    func viewPreparation() {
        contentViewOutlet.layer.cornerRadius = 20.0
        creatingThemeTextViewOutlet.layer.cornerRadius = 10.0
        cancelCreatingThemeButtonOutlet.layer.cornerRadius = 10.0
        finishCreatingThemeButtonOutlet.layer.cornerRadius = 10.0
        
        contentViewOutlet.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        creatingThemeTextViewOutlet.delegate = self
        
        if (selfMadeTheme != nil) && (selfMadeTheme!.isEmpty == false) {
            creatingThemeTextViewOutlet.text = selfMadeTheme!
        }
        else {
            creatingThemeTextViewOutlet.textColor = UIColor.gray
            creatingThemeTextViewOutlet.text = "お題を入力してください"
        }
        
        notification.addObserver(self, selector: #selector(self.keyboardChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPreparation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        self.bouncingView(caseNumber: 0)
        contentOrigin = contentViewOutlet.frame.origin
    }


}
