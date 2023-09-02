//
//  selectType.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 25/04/21.
//

import UIKit

class selectType: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var typeTXT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blueView.layer.borderWidth = 2
        blueView.layer.borderColor = tintColor.cgColor
        //blueView.layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        blueView.layer.cornerRadius = 8
        blueView.clipsToBounds = true
    }
    
}
