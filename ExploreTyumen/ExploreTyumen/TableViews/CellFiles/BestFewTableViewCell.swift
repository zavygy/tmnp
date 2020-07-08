//
//  BestFewTableViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 12/25/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class BestFewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tyumen = TyumenApp()
    
    var mode:CategorieBestEnum?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(type: CategorieBestEnum){
        
        
        mode = type
        
        tyumen.fillPlaces(escaping: {(success1) in
            if(success1){
                self.tyumen.fillQuests(escaping: {(success2) in
                    if(success2){
                        self.tyumen.fillCollections(escaping: {(success3) in
                            if(success3){
                                self.tyumen.fillBests(escaping: {(success) in
                                    if(success){
                                        self.collectionView.delegate = self
                                        self.collectionView.dataSource = self
                                        self.collectionView.register(UINib.init(nibName: "BestCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestCategoriesCollectionViewCell")
                                    }
                                })
                            }
                        })
                    }
                })
                
            }
        })
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension BestFewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode ?? .places {
        case .places:
            return tyumen.bestPlaces.count
        case .quests:
            return tyumen.bestQuests.count
        case .collections:
            return tyumen.bestCollections.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestCategoriesCollectionViewCell", for: indexPath) as! BestCategoriesCollectionViewCell
        
        switch mode ?? .places {
        case .places:
            let model = tyumen.getFullPlace(byId: tyumen.bestPlaces[indexPath.row])
            cell.setData(title: model?.title ?? "", imageMainUrl: model?.imageMainUrl ?? "", imageMain: UIImage(), categorie: mode ?? .places)
        case .quests:
            let model = tyumen.getFullQuest(byId: tyumen.bestQuests[indexPath.row])
            cell.setData(title: model?.title ?? "", imageMainUrl: model?.imageMainUrl ?? "", imageMain: UIImage(), categorie: mode ?? .quests)
        case .collections:
            let model = tyumen.getFullCollection(byId: tyumen.bestCollections[indexPath.row])
            cell.setData(title: model?.title ?? "", imageMainUrl: "", imageMain: UIImage(), categorie: .quests)
            
            print("")

        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 115)
    }
    
    
}
