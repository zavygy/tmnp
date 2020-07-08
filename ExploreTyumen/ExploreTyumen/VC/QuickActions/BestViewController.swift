//
//  BestViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 18/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class BestViewController: UIViewController, UIScrollViewDelegate {
    
    
    lazy var tyumen = TyumenApp()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "BestCardIntroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestCardIntroCollectionViewCell")
        
        
        tyumen.fillBests(escaping: {(success) in
            if(success){
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
            }
        })
        
        
        topBarHeight.constant = UIApplication.shared.statusBarFrame.height
        
    }
    
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension BestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tyumen.bestsModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestCardIntroCollectionViewCell", for: indexPath) as? BestCardIntroCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.setData(tyumen.bestsModels[indexPath.row])
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = 80
        let heigth: CGFloat = collectionView.layer.bounds.height - 40
        
        
        return CGSize(width: width, height: heigth)
    }
}
