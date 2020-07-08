//
//  InterestFactCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/14/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class InterestFactCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMain: LoadingImageView!
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backView: UIView!
    var vcParent:ViewController?
    var pModel:PlaceModel?
    
    
    override func awakeFromNib() {
        backView.fastFadeOut()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let screenSize = UIScreen.main.bounds

        layoutAttributes.size.width = screenSize.width - 32

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    
    
 
    
    func setData(placeModel: PlaceModel, fact: String, mainVC: ViewController){
        titleLabel.text = placeModel.title
        imageMain.loadImageWithCache(withUrl: placeModel.imageMainUrl ?? "")
        factLabel.text = fact
        
        self.vcParent = mainVC
        self.pModel = placeModel
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.gotoVC(gesture:)))
        
        self.contentView.addGestureRecognizer(tapGestureRec)
        
        backView.fastFadeIn()
    }
    
    @objc func gotoVC(gesture: UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
        vc.placeFullModel = pModel
        vcParent?.present(vc, animated: true, completion: nil)
    }
}
