//
//  InAppPurchases.swift
//  AI Chat Bot
//
//  Created by Admin on 20/08/23.
//

import UIKit
import RevenueCat
import SafariServices

enum IPA:String {
    case Weekly = "ChatBotWeekly"
    case Yearly = "ChatBotYearly"
}

var isProTrigger:(() -> ())?

class InAppPurchases: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var weekTitle: UILabel!
    @IBOutlet weak var yearlyTitle: UILabel!
    
    
    let backGroundColor = #colorLiteral(red: 0.05986089259, green: 0.07497294992, blue: 0.08328766376, alpha: 1)
    let selectedColor = #colorLiteral(red: 0, green: 0.6928513646, blue: 0.6272605658, alpha: 0.2620550497)
    let borderColor =  #colorLiteral(red: 0, green: 0.6928513646, blue: 0.6272605658, alpha: 1)
    
    var package:Package?
    var package2:Package?
    
    var selectedPackage:Package?
    
    @IBOutlet weak var yearlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyButton.borderColorV = borderColor
        yearlyButton.borderColorV = borderColor
        yearlyButton.backgroundColor = selectedColor
        revenuCat()
        
        self.skipButton.alpha = 0.0
        self.skipButton.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1.5) {
                self.skipButton.alpha = 1.0
            }
        }
        
        
    }
    
    
    private func revenuCat(){
        Purchases.shared.getOfferings { (offerings, error) in
            
            if let offerings = offerings {
                
                guard let package = offerings[IPA.Weekly.rawValue]?.availablePackages.first else {
                    return
                }
                
                guard let package2 = offerings[IPA.Yearly.rawValue]?.availablePackages.first else {
                    return
                }
                
                self.package = package
                self.package2 = package2
                self.selectedPackage = package2
                
                
                let weekPrice = offerings[IPA.Weekly.rawValue]?.weekly?.localizedPriceString
                
                
                let YearPrice = offerings[IPA.Yearly.rawValue]?.annual?.localizedPriceString
                
                
                self.weekTitle.text = (weekPrice ?? "") + " / Week"
                self.yearlyTitle.text = (YearPrice ?? "") + " / Year"
                
                
                
            }
        }
    }
    
    @IBAction func weeklyButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedPackage = package
    }
    
    @IBAction func yearlyButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedPackage = package2
    }
    
    @IBAction func subscriptionButton(_ sender: UIButton) {
        //let tag = sender.tag
        yearlyButton.backgroundColor = backGroundColor
        weeklyButton.backgroundColor = backGroundColor
        sender.backgroundColor = selectedColor
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        self.skipButton.isHidden = true
        self.continueButton.isUserInteractionEnabled = false
        
        if selectedPackage != nil {
            startIndicator(selfo: self, UIView: self.view)
            Purchases.shared.purchase(package: selectedPackage!) { (transaction, purchaserInfo, error, userCancelled) in
                self.skipButton.isHidden = false
                self.continueButton.isUserInteractionEnabled = true
                //print(purchaserInfo,error)
                
                if !(purchaserInfo?.entitlements.active.isEmpty ?? true) {
                    
                    self.PerchesedComplte()
                    
                }else{
                    //self.backButtonoutlet.isHidden = false
                    self.stopIndicator()
                    
                }
                
            }
            
        }
        
    }
    
    func PerchesedComplte(){
        
        stopIndicator()
        
        Manager.isPro = true
        isProTrigger?()
        
        
        let alert = UIAlertController(title: "Congratulations !", message: "You are a pro member now. Enjoy seamless experience with all features unlock.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dismiss(animated: true)
                }
            case .cancel:
                print("")
            case .destructive:
                print("")
            @unknown default:
                fatalError()
            }}))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func privacy(_ sender: Any) {
        let url = URL(string: "https://apps15.com/privacy.html")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func restore(_ sender: Any) {
        
        
    }
    
    @IBAction func toc(_ sender: Any) {
        let url = URL(string: "https://apps15.com/termsofuse.html")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
    }
    
    var indicator = UIActivityIndicatorView()
    
    func startIndicator(selfo:UIViewController,UIView:UIView) {
        indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.color = borderColor
        UIView.addSubview(indicator)
        indicator.center = CGPoint(x: UIView.frame.size.width / 2.0, y: (UIView.frame.size.height) / 2.0)
        indicator.startAnimating()
    }
    
    
    func stopIndicator() {
        indicator.stopAnimating()
    }
    
    @IBAction func skip(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}


struct Manager {
    
    private static let isProKey = "isPro"
    private static let travalData = "travalData"
    private static let numberofTimesAppOpenKey = "numberofTimesAppOpen"
    private static let depthSelected = "depthSelected"
    private static let queryHit = "queryHit"
    private static let historyArrayKey = "historyArray"
    
    
    
    static var isPro: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isProKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isProKey)
        }
    }
    
    static var stateData: Data {
        get {
            return UserDefaults.standard.data(forKey: travalData) ?? Data()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: travalData)
        }
    }
    
    
    static var queryHitValue: Int {
        get {
            return UserDefaults.standard.integer(forKey: queryHit)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: queryHit)
        }
    }
    
    static var numberofTimesAppOpen: Int {
        get {
            return UserDefaults.standard.integer(forKey: numberofTimesAppOpenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: numberofTimesAppOpenKey)
        }
    }
    
    static var depthSelectedValue: Int {
        get {
            return UserDefaults.standard.integer(forKey: depthSelected)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: depthSelected)
        }
    }
    
    static var historyArray: [[String]] {
        get {
            return UserDefaults.standard.array(forKey: historyArrayKey) as? [[String]] ?? []
        }
        set {
            var newArray = newValue
            
            //Item to remove
            let itemcountTotel = 50
            let ifThendelete = 10
            if newArray.count > itemcountTotel {
                
                let itemsToRemove = newArray.count - itemcountTotel + ifThendelete
                if itemsToRemove > 0 {
                    newArray.removeFirst(itemsToRemove)
                }
            }
            
            UserDefaults.standard.set(newArray, forKey: historyArrayKey)
        }
    }
    
}
