//
//  CollectiongroupCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/16/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class CollectiongroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView1: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    
    @IBOutlet weak var frontLayerView: UIView!
    
    @IBOutlet weak var viewForMainScreen: UIView!
    
    
    var vcParent: ViewController?
    
    var model: CollectionModel?
    
    lazy var tyumen = TyumenApp()
    
    override func awakeFromNib() {
        titleLabel.text = ""
        shortDescription.text = ""
    }
    
    func setData(model: CollectionModel){
        
        
        
        titleLabel.text = model.title
        shortDescription.text = model.shortDescription
        
//        viewForMainScreen.isHidden = true
        
        self.model = model
        imageView1.loadImageWithCache(withUrl: model.imageMainUrl)
        
        
        if(vcParent != nil){
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentCollection(gesture:)))
            
            frontLayerView.addGestureRecognizer(tapGesture)
        }
        
    }
    
    func setRandomCollection(vc: ViewController){
        self.vcParent = vc
        viewForMainScreen.isHidden = false
        tyumen.fillCollections(escaping: {(success) in
            let model = self.tyumen.collections.shuffled()[0]
            
            self.setData(model: model)
        })
    }
    
    @objc func presentCollection(gesture: UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "DetailedCollection", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailedCollectionViewController") as! DetailedCollectionViewController
        
        vc.collectionModel = model
        vcParent?.present(vc, animated: true, completion: nil)
    }
    
}
