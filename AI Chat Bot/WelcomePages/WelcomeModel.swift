//
//  WelcomeModel.swift
//  AI Chat Bot
//
//  Created by Admin on 27/08/23.
//

import Foundation
import UIKit


class AnimateButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        self.isHidden = true
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 1.3) {
            self.alpha = 1
            self.isHidden = false
        }
    }
    
}
