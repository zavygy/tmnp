//
//  QuestDetailedViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 17/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation

enum extendState {
    case extended
    case minimal
}

class QuestDetailedViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    var style:UIStatusBarStyle = .lightContent
    
    //    @IBOutlet weak var statisticCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewPlacesHeigth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewPlaces: UICollectionView!
    @IBOutlet weak var titleMainLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var darkTintView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageViewBackGround: LoadingImageView!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var statusBarView: UIView!
    
    var questFullModel:QuestModel?
    
    
    lazy var tyumen = TyumenApp()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarView.fastFadeOut()
        
//        buttonStart.layer.cornerRadius = 20
        
        buttonStart.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        buttonStart.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        buttonStart.layer.shadowRadius = 10
        buttonStart.layer.shadowOpacity = 0.6
        buttonStart.layer.masksToBounds = false
        
        
        
        
        statusBarHeight.constant = UIApplication.shared.statusBarFrame.height
        
        titleMainLabel.text = questFullModel?.title
        subtitleLabel.text = questFullModel?.subtitle
        //        descriptionLabel.text = questFullModel!.description1! + questFullModel!.description2!
        
        
        timeLabel.text = questFullModel?.timeToComplete
        distLabel.text = questFullModel?.distToComplete
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        
        paragraphStyle.lineSpacing = 1.5
        
        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.init(rgbColorCodeRed: 50, green: 59, blue: 69, alpha: 0.8)] as [NSAttributedString.Key : Any]
        
        let attributedString = NSMutableAttributedString(string: (questFullModel!.description1! + questFullModel!.description2!), attributes: hyphenAttribute)
        
        
        descriptionLabel.attributedText = attributedString
        
        imageViewBackGround.loadImageWithCache(withUrl: questFullModel!.imageMainUrl!)
        
        scrollView.delegate =  self
        
        collectionViewPlaces.register(UINib(nibName: "BestCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestCategoriesCollectionViewCell")
    
        
        tyumen.fillPlaces(escaping: {(success) in
            
            self.collectionViewPlaces.delegate = self
            self.collectionViewPlaces.dataSource = self
            
        })
        
        collectionViewPlacesHeigth.constant = 120
        
        
    }
    
    
    @IBAction func startAction(_ sender: Any) {
        let backModel = BackgroundLayerQuestModel(allPlacesInQuest: questFullModel?.placesForQuests?.count ?? 0, placePositionInQuest: 0)
        
        let storyb = UIStoryboard(name: "Quest", bundle: nil)
        
        let vc = storyb.instantiateViewController(withIdentifier: "QuestNextPlaceViewController") as! QuestNextPlaceViewController
        
        vc.backModel = backModel
        vc.questModel = questFullModel
        
        self.present(vc, animated: true, completion: nil)
        
    }
    

    
    @IBAction func dismis(_ sender: Any) {
        //        if(self.style == .lightContent){
        //            self.style = .default
        //        }else{
        //            self.style = .lightContent
        //        }
        //
        //        setNeedsStatusBarAppearanceUpdate()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

extension QuestDetailedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == collectionViewPlaces){
            return questFullModel?.placesForQuests?.count ?? 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == collectionViewPlaces){
            let cell = collectionViewPlaces.dequeueReusableCell(withReuseIdentifier: "BestCategoriesCollectionViewCell", for: indexPath) as! BestCategoriesCollectionViewCell
            
            let pModel = tyumen.getFullPlace(byId: questFullModel?.placesForQuests?[indexPath.row] ?? 0) ?? PlaceModel()
            
            cell.setData(title: pModel.title ?? "", imageMainUrl: pModel.imageMainUrl ?? "", imageMain: UIImage(), categorie: .places)
            
            
            cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 10
            cell.layer.shadowOpacity = 0.6
            cell.layer.masksToBounds = false
            
            return cell
        }else{
            return UICollectionViewCell()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == collectionViewPlaces){
            let widthCell = 200
            
            let heigth = 115
            
            return CGSize(width: widthCell, height: heigth)
        }else{
            return CGSize(width: 0, height: 0)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == collectionViewPlaces){
            let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
            
            
            vc.placeFullModel = tyumen.getFullPlace(byId: questFullModel?.placesForQuests?[indexPath.row] ?? 0)
            
            
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}


extension QuestDetailedViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView == self.scrollView){
            let offset = scrollView.contentOffset.y
            
            if(230 - offset <= statusBarHeight.constant + 16){
                statusBarView.fastFadeIn()
                self.style = .default
                setNeedsStatusBarAppearanceUpdate()
            }else{
                self.style = .lightContent
                setNeedsStatusBarAppearanceUpdate()
                statusBarView.fastFadeOut()
            }
            
            darkTintView.alpha = offset/450
        }
    }
    
}
