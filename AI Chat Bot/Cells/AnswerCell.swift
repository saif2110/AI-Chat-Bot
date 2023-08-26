//
//  QuestionCell.swift
//  AI Chat Bot
//
//  Created by Admin on 19/08/23.
//

import AVFoundation
import UIKit

class AnswerCell: UITableViewCell {
    
    @IBOutlet weak var textCopied: UILabel!
    
    @IBOutlet weak var output: UILabel!
    
    
    static var identifire : String {
        return String(describing: self)
    }

    @IBAction func copyText(_ sender: Any) {
        UIPasteboard.general.string = output.text
        textCopied.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.textCopied.isHidden = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        //mainView.round(corners: [.topRight,.topLeft,.bottomLeft], radius: 0)
    }

    @IBOutlet weak var mainView: UIView!
    
    @IBAction func soundButton(_ sender: Any) {
        texttoSpeech(text: output.text ?? "")
    }
    
}
