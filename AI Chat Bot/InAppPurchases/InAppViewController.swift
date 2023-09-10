//
//  InAppPurchases.swift
//  Blood Oxygen Level App
//
//  Created by Junaid Mukadam on 19/06/21.
//

import UIKit
import RevenueCat
import SafariServices
import StoreKit
import CoreLocation


class InAppViewController: UIViewController {
  @IBOutlet weak var priceLabel: UILabel!
  
    var package:Package?
  
   @IBOutlet weak var backButtonoutlet:UIButton!
    
  @IBOutlet weak var continueOutlet: UIButton!{
    didSet{
       // continueOutlet.applyNeuBtnStyle(type: .elevatedFlat,attributedTitle: textMaker(boldText: "CONTINUE", normalText: "", boldSize: 22, normalSize: 16))
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
//      continueOutlet.isHidden = true
//      
//      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//          UIView.transition(with: self.continueOutlet, duration: 0.4,
//                            options: .transitionCrossDissolve,
//                            animations: {
//              self.continueOutlet.isHidden = false
//          })
//      }
    
    
      Purchases.shared.getOfferings { (offerings, error) in
      
      if let offerings = offerings {
        
          guard let package2 = offerings[IPA.Weekly.rawValue]?.availablePackages.first else {
          return
        }
        
          self.package = package2
      
        
        let priceone = offerings[IPA.Weekly.rawValue]?.weekly?.localizedPriceString
        

        // self.priceLabel.text = "Three days free trial. After free trial, \(String(describing: priceone ?? "")) billed weekly auto renewable."
          
          self.priceLabel.text = "Unlock the full potential of our app with a pro membership with all features at just \(String(describing: priceone ?? "")) billed weekly auto renewable."
        
        
        stopIndicator()
        
      }
    }
    
  }
  
  var weekBool = true
  
  
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.transition(with: backButtonoutlet, duration: 3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.backButtonoutlet.isHidden = false
        })
        
        if Apps15init.shared.HSB {
            self.backButtonoutlet.isHidden = Apps15init.shared.HSB
        }
        continueOutlet.clipsToBounds = true
        continueOutlet.layer.cornerRadius = continueOutlet.bounds.height/2
    }
  
  override func viewDidDisappear(_ animated: Bool) {
//    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//      SKStoreReviewController.requestReview(in: scene)
//    }
  }
  
  func PriceMessage(price:String,save:String) -> NSAttributedString {
    let attrString = NSMutableAttributedString(string: price+"\n",
                                               attributes: [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 18)!]);
    
    attrString.append(NSMutableAttributedString(string: save,
                                                attributes: [NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 10)!]))
    return attrString
  }
  
  func select(vw:UIView){
    vw.layer.borderWidth = 2
    vw.layer.borderColor = #colorLiteral(red: 0.4622848034, green: 0.8205576539, blue: 0.7943418622, alpha: 1)
  }
  
  func Deselect(vw:UIView){
    vw.layer.borderWidth = 0
    vw.layer.borderColor = UIColor.clear.cgColor
  }
  
  
//  func customView(vw:UIView){
//    vw.layer.cornerRadius = 10
//    vw.shadow2()
//  }
  
  func customLabelBanner(vw:UILabel){
    vw.layer.masksToBounds = true
    vw.layer.cornerRadius = 10
    vw.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
  }
  
  func upperView(vw:UIView){
    vw.layer.masksToBounds = true
    vw.layer.cornerRadius = 10
    vw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  
    @IBAction func continueAction (_ sender: Any) {
        self.backButtonoutlet.isHidden = true
        
        if package != nil {
            startIndicator(self: self)
            Purchases.shared.purchase(package: package!) { (transaction, purchaserInfo, error, userCancelled) in
                
                //print(purchaserInfo,error)
                
                if !(purchaserInfo?.entitlements.active.isEmpty ?? true) {
                    
                    self.PerchesedComplte()
                    
                }else{
                    self.backButtonoutlet.isHidden = false
                    stopIndicator()
                    
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
  
  @IBAction func restore(_ sender: Any) {
    
      Purchases.shared.restorePurchases { (purchaserInfo, error) in
      
        if !(purchaserInfo?.entitlements.active.isEmpty ?? true) {
            
            self.PerchesedComplte()
        
      }
    }
    
  }
  
  
  
  
  @IBAction func back(_ sender: Any) {
          self.dismiss(animated: false) {
              
//              DispatchQueue.main.async {
//                  if let topMostViewController = UIApplication.shared.topMostViewController {
//                      //let vc = TypeVC()
//                       //let vc = SelectUnit()
//                      let vc = InAppViewTwo()
//
//                      //                              let story = UIStoryboard(name: "Main", bundle: Bundle.main)
//                      //                              let vc = story.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
//                      vc.modalPresentationStyle = .fullScreen
//                      topMostViewController.present(vc, animated: false)
//
//                  }
//              }
              
          }
      }
    
    
  
  @IBAction func toc(sender:UIButton){
    let url = URL(string: "https://apps15.com/termsofuse.html")
    let vc = SFSafariViewController(url: url!)
    present(vc, animated: true, completion: nil)
  }
  
  @IBAction func privacyPolicy(sender:UIButton){
    let url = URL(string: "https://apps15.com/privacy.html")
    let vc = SFSafariViewController(url: url!)
    present(vc, animated: true, completion: nil)
  }
  
}
