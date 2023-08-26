//
//  QuestionCell.swift
//  AI Chat Bot
//
//  Created by Admin on 19/08/23.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var output: UILabel!
    
    static var identifire : String {
        return String(describing: self)
    }
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var textCopied: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
    }

    @IBOutlet weak var mainView: UIView!
    
    @IBAction func copyButtonAction(_ sender: Any) {
        UIPasteboard.general.string = output.text
        textCopied.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.textCopied.isHidden = true
        }
    }
    

}
