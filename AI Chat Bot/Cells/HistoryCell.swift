//
//  HistoryCell.swift
//  AI Chat Bot
//
//  Created by Admin on 25/08/23.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var quetion: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    var viewMoreButtonTapped:(()->())?
    
    static var identifire : String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func viewMore(_ sender: UIButton) {
        viewMoreButtonTapped?()
    }
    
}
