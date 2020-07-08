//
//  TenThongsToDoViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/26/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class TenThongsToDoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageMain: UIImageView!
    
    @IBOutlet weak var closeView: UIView!
    lazy var tyumen = TyumenApp()
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.hidesForSinglePage = true
        
         collectionView.register(UINib.init(nibName: "ThingsThatShouldBeDoneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ThingsThatShouldBeDoneCollectionViewCell")
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(TenThongsToDoViewController.quickActionsButtonTapped(gesture:)))
        
        closeView.addGestureRecognizer(tapGesture1)
        
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        imageMain.image = #imageLiteral(resourceName: "mainTenT.png").blurEffect()
        collectionView.reloadData()
        
    }
    
    
    @objc func quickActionsButtonTapped(gesture: UIGestureRecognizer){
        if(gesture.view == closeView){
            closeView.alpha = 1
            self.dismiss(animated: true, completion: nil)
        }
    }

 
}


extension TenThongsToDoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = tyumen.tenThings.count

        return tyumen.tenThings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThingsThatShouldBeDoneCollectionViewCell", for: indexPath) as! ThingsThatShouldBeDoneCollectionViewCell
        
        
        cell.setData(tyumen.tenThings[indexPath.row], vc: self)
        
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        cell.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.layer.frame.width - 20*2
        let heigth:CGFloat = collectionView.layer.frame.height - 10
        
        
        
        return CGSize(width: width, height: heigth)
        
        
    }

    
    
}
