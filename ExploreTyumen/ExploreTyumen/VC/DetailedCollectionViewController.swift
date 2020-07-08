//
//  DetailedCollectionViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/17/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation
class DetailedCollectionViewController: UIViewController {
    @IBOutlet weak var imageView1: LoadingImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dismisView: UIView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewMain: UIScrollView!
    var collectionModel:CollectionModel?
    
    var heightForColView: CGFloat = 0
    
    
    lazy var tyumen = TyumenApp()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.fadeOut()
        imageView1.fadeOut()
        self.imageView1.loadImageWithCache(withUrl: self.collectionModel!.imageMainUrl)

        
        self.titleLabel.text = self.collectionModel?.title ?? ""

        
        collectionViewHeight.constant = 0
        
        
        var descriptionForLabel: String = self.collectionModel?.shortDescription ?? ""
        
       
        
        let paragraphStyle = NSMutableParagraphStyle()

        
        paragraphStyle.hyphenationFactor = 1.0
        
        paragraphStyle.lineSpacing = 1.5
        
        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 17)] as [NSAttributedString.Key : Any]
        
      
        
        
        

        subtitleLabel.text = collectionModel!.shortDescription
        
        
        tyumen.fillPlaces(escaping: {(success) in
            
            
            
            
          
            
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.quickActionsButtonTapped(gesture:)))
            
            self.dismisView.addGestureRecognizer(tapGesture1)
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.register(UINib.init(nibName: "CollectionPlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionPlaceCollectionViewCell")
            self.collectionView.reloadData()
            
            DispatchQueue.main.async {
                 self.collectionViewHeight.constant = self.heightForColView
            }
           
            
            self.scrollViewMain.delegate = self
            
            self.imageView1.fadeIn()
           
            
            self.collectionView.fadeIn()
        })
    }
        
        
        @objc func quickActionsButtonTapped(gesture: UIGestureRecognizer){
            if(gesture.view == dismisView){
                dismisView.alpha = 1
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
           
        }
        
        
        
            
            
       
        
}


extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String?, with color: UIColor) {
        
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
}

extension DetailedCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModel?.placesId.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionPlaceCollectionViewCell", for: indexPath) as! CollectionPlaceCollectionViewCell
        
        
        let width = collectionView.frame.width - 12*2

        let m = tyumen.getFullPlace(byId: collectionModel?.placesId[indexPath.row] ?? 0) ?? PlaceModel()
        
        
         cell.setData(m)
        
        cell.titleLabelConstraint.constant = heightForLable(labelWidth: width - 124, numberOfLines: 2, labelText: m.title ?? "", labelFont: UIFont(name: "Roboto-Bold", size: 20) ?? UIFont())
        
        cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
        
        vc.placeFullModel = tyumen.getFullPlace(byId: collectionModel?.placesId[indexPath.row] ?? 0)
        
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        let m = tyumen.getFullPlace(byId: collectionModel?.placesId[indexPath.row] ?? 0) ?? PlaceModel()
        
        let width = collectionView.frame.width - 12*2
        
        
        let heigth = 164.5 + 12 + heightForLable(labelWidth: width - 12*2, labelText: m.subtitle ?? "", labelFont: UIFont(name: "Roboto-Regular", size: 17) ?? UIFont.systemFont(ofSize: 18)) + heightForLable(labelWidth: width - 124, numberOfLines: 2, labelText: m.title ?? "", labelFont: UIFont(name: "Roboto-Bold", size: 20) ?? UIFont())
        
        
        heightForColView += heigth + 14
        

        return CGSize(width: width, height: heigth)
    }
    
    func heightForLable(labelWidth: CGFloat, numberOfLines: Int = 0, labelText: String, labelFont: UIFont) -> CGFloat {
        let tempLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        tempLabel.numberOfLines = numberOfLines
        tempLabel.text = labelText
        tempLabel.font = labelFont
        tempLabel.sizeToFit()
        
        return tempLabel.frame.height
    }
    
    
    
}


extension DetailedCollectionViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == self.scrollViewMain){
            if self.scrollViewMain.isTracking && scrollViewMain.contentOffset.y < -70 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
