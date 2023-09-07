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
import Firebase
import AppTrackingTransparency
import FacebookCore
import FacebookAEM
import SwiftUI


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
        
        
        //Manager.isPro = false
        FirebaseApp.configure()
        isSubsActive()
        Apps15init.shared.start(id: "apps15.AI-Chat-Bot")
        
        ApplicationDelegate.shared.application(application,
           didFinishLaunchingWithOptions: launchOptions)
        Settings.shared.isAutoLogAppEventsEnabled = false
        Settings.shared.isAdvertiserIDCollectionEnabled = false
        checkATTStatus()
        
        
        Thread.sleep(forTimeInterval: 1.5)
        return true
    }
    
    func isSubsActive(){
        
        Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
            
            if !(purchaserInfo?.entitlements.active.isEmpty ?? true) {
                Manager.isPro = true
            }else{
                Manager.isPro = false
            }
            
        }
    }
    
    func checkATTStatus() {
        let isConsented = ATTrackingManager.trackingAuthorizationStatus == .authorized
        Settings.shared.isAutoLogAppEventsEnabled = isConsented
        //Settings.shared.setAdvertiserTrackingEnabled(isConsented)
        Settings.shared.isAdvertiserIDCollectionEnabled = isConsented
        }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                
                let isConsented = status == .authorized
                Settings.shared.isAutoLogAppEventsEnabled = isConsented
                Settings.shared.isAdvertiserIDCollectionEnabled = isConsented
                switch status {
                case .authorized:
                    break
                case .denied:
                    break
                default:
                    break
                }
            }
        }
    }
    
}

extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, readyForPromotedProduct product: StoreProduct, purchase makeDeferredPurchase: @escaping StartPurchaseBlock) {
        makeDeferredPurchase { (transaction, customerInfo, error, success) in
            print("Yay")
        }
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

