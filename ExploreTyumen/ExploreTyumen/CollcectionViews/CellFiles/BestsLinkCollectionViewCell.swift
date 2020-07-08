//
//  BestsLinkCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 2/17/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class BestsLinkCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var colViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    
    var model: BestCardIntroModel?
    var tyumen = TyumenApp()
    
    override func awakeFromNib() {
        backView.alpha = 0
    }
    
    func setData(_ m: BestCardIntroModel){
        self.model = m
        self.titleLabel.text = m.title
        self.colViewHeight.constant = CGFloat(m.placesId.count * 75)
        collectionView.register(UINib(nibName: "LittlePlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LittlePlaceCollectionViewCell")
        
        
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
                self.backView.fastFadeIn()
            }
        })
    }
    
}

extension BestsLinkCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.placesId.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LittlePlaceCollectionViewCell", for: indexPath) as! LittlePlaceCollectionViewCell
        
        cell.setData(tyumen.getFullPlace(byId: model?.placesId[indexPath.row] ?? 0) ?? PlaceModel())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.layer.bounds.width
        return CGSize(width: width, height: 75)
    }
    
    
}
