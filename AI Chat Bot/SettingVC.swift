//
//  SettingVC.swift
//  AI Chat Bot
//
//  Created by Admin on 26/08/23.
//

import UIKit
import SafariServices


class SettingVC: UIViewController {
    
    @IBOutlet weak var proButtunOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isProTrigger = {
            self.whenPROactivated()
        }
        
        if Manager.isPro {
            whenPROactivated()
        }
        
    }
    
    @IBAction func proButton(_ sender: UIButton) {
        openInappPurchase(context: self)
    }
    
    
    private func whenPROactivated(){
        self.proButtunOutlet.tintColor = .systemOrange
    }
    
    
    @IBAction func settingActionButton(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            let vc = SelectUnit()
            vc.cameFromSetting = true
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
            break
        case 1:
            let email = "feedback@apps15.com"
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown App Version"
            let subject = "AI Chat Bot (Version \(appVersion))"

            if let emailURL = URL(string: "mailto:\(email)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                UIApplication.shared.open(emailURL)
                
            }
            break
        case 2:
            let url = URL(string: "https://apps.apple.com/developer/junaid-mukadam/id1365586675")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
            }
            break
        case 3:
           openWebContent(url: "https://apps15.com/privacy.html")
            break
        case 4:
            openWebContent(url: "https://apps15.com/termsofuse.html")
            break
        default:
            break
        }
        
    }
    
    func openWebContent(url:String) {
        if let url = URL(string: url) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
}
