//
//  OneDayViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 14/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    @IBOutlet weak var noConnectionLabel: UILabel!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    
    lazy var tyumen = TyumenApp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noConnectionLabel.fadeOut()
        
        activityIndic.startAnimating()
        
        collectionView.fadeOut()
        
        topBarHeight.constant = UIApplication.shared.statusBarFrame.height

        scrollViewMain.delegate = self
//       CollectiongroupCollectionViewCell
        
        collectionView.register(UINib.init(nibName: "CollectiongroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectiongroupCollectionViewCell")

        
       
        
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                self.tyumen.fillCollections(escaping: {(suc) in
                    if(suc){
                        self.collectionView.delegate = self
                        self.collectionView.dataSource = self
                        self.collectionView.reloadData()
                        
                        self.collectionViewHeight.constant = CGFloat(self.tyumen.collections.count*(150 + 16))
                        
                        self.activityIndic.fadeOut()
                        self.collectionView.fadeIn()
                        
                    }else{
                        self.activityIndic.fadeOut()
                        self.noConnectionLabel.fadeIn()
                        
                    }
                })
            }else{
                self.activityIndic.fadeOut()
                self.noConnectionLabel.fadeIn()
            }
        })
        
    }
    
    

    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == scrollViewMain){
            let shouldScrollEnabled: Bool
            if self.scrollViewMain.isTracking && scrollViewMain.contentOffset.y < -70 {
                self.dismiss(animated: true, completion: nil)
            } else {
                shouldScrollEnabled = true
            }
        }
    }
    
}

extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tyumen.collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectiongroupCollectionViewCell", for: indexPath) as! CollectiongroupCollectionViewCell
        let model = tyumen.collections[indexPath.row]
        
        cell.setData(model: model)
        
//        cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        cell.layer.shadowRadius = 10
//        cell.layer.shadowOpacity = 0.6
//        cell.layer.masksToBounds = false
//
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "DetailedCollection", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailedCollectionViewController") as! DetailedCollectionViewController
        
        vc.collectionModel = tyumen.collections[indexPath.row]
        
        self.present(vc, animated: true, completion: nil)
    }
}
