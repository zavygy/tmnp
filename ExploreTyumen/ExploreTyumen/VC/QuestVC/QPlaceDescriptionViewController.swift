//
//  QuestPlaceDiscriptionViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 1/8/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class QPlaceDescriptionViewController: UIViewController {
    
    @IBOutlet weak var mainImage: LoadingImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var iconPlaceView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    var backModel:BackgroundLayerQuestModel?
    var questModel: QuestModel?
    
    lazy var tyumen = TyumenApp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconPlaceView.asCircle()
        iconPlaceView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        iconPlaceView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        iconPlaceView.layer.shadowRadius = 8
        iconPlaceView.layer.shadowOpacity = 0.5
        iconPlaceView.layer.masksToBounds = false
        
        
        nextButton.layer.cornerRadius = 20
        
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                let placeModel =  self.tyumen.getFullPlace(byId: self.questModel?.placesForQuests?[self.backModel?.placePositionInQuest ?? 0] ?? 0)
                
                self.titleLabel.text = placeModel?.title
            
                self.mainImage.loadImageWithCache(withUrl: placeModel?.imageMainUrl ?? "")
                
                let description1 = self.questModel?.descriptionForPlaces?[self.backModel?.placePositionInQuest ?? 0].firstDescription ?? ""
                let description2 = self.questModel?.descriptionForPlaces?[self.backModel?.placePositionInQuest ?? 0].secondDescription ?? ""
                
                let duoDescription:String =  description1 + " " + description2
                
                
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.hyphenationFactor = 1.0
                
                let hyphenAttribute = [
                    NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 18)] as [NSAttributedString.Key : Any]
                
                let attributedString = NSMutableAttributedString(string: (duoDescription), attributes: hyphenAttribute)
                
                
                self.descriptionLabel.attributedText = attributedString
                
            }
        })
        
        
    }
    
    
    
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QQuestionViewController") as! QQuestionViewController
        
        vc.backModel = backModel
        vc.questModel = questModel
        self.present(vc, animated: true, completion: nil)
    }
    
}
