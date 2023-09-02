//
//  TypeVC.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 25/04/21.
//

import UIKit
import AppTrackingTransparency
import StoreKit

class SelectUnit: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var cameFromSetting = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectType", for: indexPath) as! selectType
        
        cell.typeTXT.text = type[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        return CGSize(width: size, height: 65)
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
        resetAll()
        cell.typeTXT.textColor = .white
        cell.imageVIew.tintColor = .white
        cell.blueView.backgroundColor = tintappColor
        
        selectdType.append(cell.typeTXT.text!)
        if selectdType.count > 0{
            getStartedOutlet.alpha = 1
        }
    }
    
    func deSelect(cell:selectType) {
        cell.typeTXT.textColor = UIColor.white
        cell.imageVIew.tintColor = UIColor.white
        cell.blueView.backgroundColor = backGroundColor
        //cell.blueView.layer.borderColor = UIColor.white.cgColor
        
        selectdType.removeAll { $0 == cell.typeTXT.text! }
        if selectdType.count == 0{
            getStartedOutlet.alpha = 0.5
            getStartedOutlet.setTitle("Select Urgency", for: .normal)
        }
    }
    
    func resetAll(){
        for cellView in collectionView.visibleCells {
           let cell  = cellView as? selectType
            deSelect(cell: cell!)
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
    
    var type = ["Short Research (Faster Response Time)","Medium Research (Medium Response Time)","Deep Research (Long Response Time)","Just Want to Use as Fun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedOutlet.alpha = 0.5
       
        getStartedOutlet.setTitleColor(UIColor.white, for: .normal)
        
        getStartedOutlet.setTitle("Select Any", for: .normal)
        
        self.collectionView.register(UINib(nibName: "selectType", bundle: nil), forCellWithReuseIdentifier: "selectType")
        
        
        //startIndicator(selfo: self, UIView: self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    @IBAction func getStarted(_ sender: Any) {
        
        guard !cameFromSetting else {
            
            self.dismiss(animated: true)
            
            return }
        
        
        if !Manager.isPro {
            let vc = InAppPurchases()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
          SKStoreReviewController.requestReview(in: scene)
        }
        
    }
    
}


