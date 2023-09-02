//
//  WelcomeEnd.swift
//  AI Chat Bot
//
//  Created by Admin on 27/08/23.
//

import UIKit

class WelcomeEnd: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func contineBotton(_ sender: Any) {
        let vc = TypeVC()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
