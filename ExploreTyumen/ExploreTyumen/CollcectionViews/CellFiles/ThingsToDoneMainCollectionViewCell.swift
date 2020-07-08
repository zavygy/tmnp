//
//  ThingsToDoneMainCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/26/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class ThingsToDoneMainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backView: UIView!
    
    lazy var tyumen = TyumenApp()
    
    var vcParent: ViewController?
    

    override func awakeFromNib() {
        backView.alpha = 0
        imageMain.image = #imageLiteral(resourceName: "mainTenT.png").blurEffect()
        
        
          let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.goToVC(gesture:)))
        
        
        mainView.addGestureRecognizer(tapGestureRec)
        backView.fastFadeIn()
    }
    
    func setData(_ vc: ViewController){
        vcParent = vc
    }
    
    @objc func goToVC(gesture: UIGestureRecognizer){
        let vc = vcParent?.storyboard?.instantiateViewController(withIdentifier: "TenThongsToDoViewController") as! TenThongsToDoViewController
        
        vcParent?.present(vc, animated: true, completion: nil)
    }
    
}
