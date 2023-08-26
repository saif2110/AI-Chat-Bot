//
//  AppDelegate.swift
//  AI Chat Bot
//
//  Created by Admin on 19/08/23.
//

import UIKit
import AVFoundation
import IQKeyboardManagerSwift
import RevenueCat


let backGroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
let tintappColor = #colorLiteral(red: 0, green: 0.6941176471, blue: 0.6274509804, alpha: 1)
let synthesizer = AVSpeechSynthesizer()
let numberofTimeUsage = 10

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launchhn hn.
        IQKeyboardManager.shared.keyboardDistanceFromTextField = -28
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_gXKAzHloNrDTyZHqrdGjtUISffQ")
        
        Manager.numberofTimesAppOpen = Manager.numberofTimesAppOpen + 1
        
        
         //Manager.isPro = true
        
        Thread.sleep(forTimeInterval: 1.5)
        
        return true
    }
    
}


extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


func texttoSpeech(text:String){
    let utterance = AVSpeechUtterance(string: text)
    utterance.rate = 0.45
    utterance.postUtteranceDelay = 0.2
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    synthesizer.speak(utterance)
}



func openInappPurchase(context:UIViewController){
    if !Manager.isPro {
        let vc = InAppPurchases()
        vc.modalPresentationStyle = .fullScreen
        context.present(vc, animated: true)
    }
    
}

