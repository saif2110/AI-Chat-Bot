//
//  HistoryCell.swift
//  AI Chat Bot
//
//  Created by Admin on 25/08/23.
//

import UIKit

class HistoryCell: UITableViewCell {

    
    static var identifire : String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
