//
//  BestPlacesCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 14/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit



class BestPlacesCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMain: LoadingImageView!
    @IBOutlet weak var viewFullCollectionView: UIView!
    
    @IBOutlet weak var viewType: UIView!
    
    var massive:[BestCategorieModel] = []
    
    
    var vc:ViewController?
    
    
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
    
    override func awakeFromNib() {
        viewType.alpha = 0
        viewFullCollectionView.alpha = 0
    }
    
    
    lazy var tyumen = TyumenApp()
    func setData(vcParent: ViewController){
        
        titleLabel.text = ""
        categorieLabel.text = ""
        
        tyumen.fillPlaces(escaping: {(success) in
            self.massive = self.tyumen.bestCategorie.shuffled()
            switch self.massive[0].categorie {
            case .collections:
                self.categorieLabel.text = "Подборка"
                self.titleLabel.text = ""
                
                
            case .places:
                self.categorieLabel.text = "Место"
                self.titleLabel.text = self.tyumen.getFullPlace(byId: self.massive[0].id)?.title
                self.imageMain.loadImageWithCache(withUrl: self.tyumen.getFullPlace(byId: self.massive[0].id)?.imageMainUrl ?? "")
                
            case .quests:
                self.tyumen.fillQuests(escaping: {(suc) in
                    if(suc){
                        self.categorieLabel.text = "Квест"
                        self.titleLabel.text = self.tyumen.getFullQuest(byId: self.massive[0].id)?.title
                        self.imageMain.loadImageWithCache(withUrl: self.tyumen.getFullQuest(byId: self.massive[0].id)?.imageMainUrl ?? "")
                    }
                })
                
            default:
                print("Problem in bestMainScreenCard")
            }
            
            self.viewType.fastFadeIn()
            self.viewFullCollectionView.fastFadeIn()
            
        })
        
        self.vc = vcParent
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(BestPlacesCollectionViewCell.quickActionsButtonTapped(gesture:)))
        viewFullCollectionView.addGestureRecognizer(tapGesture1)
        
        
        
        
    }
    
    
    @objc func quickActionsButtonTapped(gesture: UIGestureRecognizer){
        if(gesture.view == viewFullCollectionView){
            switch massive[0].categorie {
            case .collections:
               print("tesssst")
                
                
            case .places:
                let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
                
                vc1.placeFullModel = tyumen.getFullPlace(byId: massive[0].id)
                
                vc?.present(vc1, animated: true, completion: nil)
                
            case .quests:
                
                let mStoryboard = UIStoryboard(name: "QuestDetailed", bundle: nil)
                
                let vc1 = mStoryboard.instantiateViewController(withIdentifier: "QuestDetailedViewController") as! QuestDetailedViewController
                
                
                vc1.questFullModel = tyumen.getFullQuest(byId: massive[0].id)
                
                vc?.present(vc1, animated: true, completion: nil)
                
            default:
                print("Problem in bestMainScreenCard")
            }
        }
    }
    
    
    
    

}

