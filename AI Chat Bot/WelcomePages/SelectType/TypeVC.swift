//
//  TypeVC.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 25/04/21.
//

import UIKit
import AppTrackingTransparency

class TypeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectType", for: indexPath) as! selectType
        
        cell.typeTXT.text = type[indexPath.item].capitalized
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 55)
    }
    
    
    var selectdType = [String]()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! selectType
        
        bounce(cell: cell)
        
        if cell.blueView.backgroundColor == tintappColor {
            deSelect(cell: cell)
        }else{
            select(cell:cell)
        }
    }
    
    func select(cell:selectType) {
        cell.typeTXT.textColor = .white
        cell.imageVIew.tintColor = .white
        cell.blueView.backgroundColor = tintappColor
        
        selectdType.append(cell.typeTXT.text!)
        if selectdType.count > 2{
            getStartedOutlet.alpha = 1
            
        }
    }
    
    func deSelect(cell:selectType) {
        cell.typeTXT.textColor = UIColor.white
        cell.imageVIew.tintColor = UIColor.white
        cell.blueView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        //cell.blueView.layer.borderColor = UIColor.white.cgColor
        
        selectdType.removeAll { $0 == cell.typeTXT.text! }
        if selectdType.count < 3 {
            getStartedOutlet.alpha = 0.5
        }
    }
    
    func bounce(cell:selectType){
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            // HERE
            cell.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) // Scale your image
            
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
                
                cell.transform = CGAffineTransform.identity // undo in 1 seconds
                
            })
        }
    }
    
    
    
    @IBOutlet weak var getStartedOutlet: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var type = ["Information", "Translation", "Education", "Entertainment", "Problem Solving","Learning", "Data Analysis", "Assistance", "Creativity", "Knowledge"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedOutlet.setTitleColor(UIColor.white, for: .normal)
        
        getStartedOutlet.setTitle("Select Three", for: .normal)
        
        self.collectionView.register(UINib(nibName: "selectType", bundle: nil), forCellWithReuseIdentifier: "selectType")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        
    }
    
    
    @IBAction func getStarted(_ sender: Any) {
        guard getStartedOutlet.alpha == 1 else {return}
        let vc = SelectUnit()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UIViewController {
    var topMostViewController : UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}


extension UIApplication {
    var topMostViewController : UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController
    }
}
