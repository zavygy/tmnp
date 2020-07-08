//
//  BestTableViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/24/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation
class BestTableViewCell: UITableViewCell {

    @IBOutlet weak var imageMain: LoadingImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    var parentVC = BestViewController()
    
    
    @IBOutlet weak var backgroundTypeView: UIView!
    
    var pModel: PlaceModel?
    var qModel: QuestModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.cornerRadius = 12
        
        
        backView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        backView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        backView.layer.shadowRadius = 10
        backView.layer.shadowOpacity = 0.8
        backView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(questModel: QuestModel, _ vc: BestViewController){
        imageMain.loadImageWithCache(withUrl: questModel.imageMainUrl ?? "")
        titlelabel.text = questModel.title
        
        qModel = questModel
        
        self.parentVC = vc

        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        
        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
            ] as [NSAttributedString.Key : Any]
        
        let attributedString = NSMutableAttributedString(string: questModel.description1 ?? "", attributes: hyphenAttribute)
        self.shortDescriptionLabel.attributedText = attributedString
        
        
        
        
        typeLabel.text = "Квест"
        backgroundTypeView.backgroundColor = UIColor(rgbColorCodeRed: 156, green: 39, blue: 176, alpha: 100)
        
    }
    
    @objc func goToVCQuest(gesture: UIGestureRecognizer){
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "QuestDetailedViewController") as! QuestDetailedViewController
        
        
        vc.questFullModel = qModel
        
        parentVC.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func goToVCPlace(gesture: UIGestureRecognizer){
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
        
        
        vc.placeFullModel = pModel
        
        parentVC.present(vc, animated: true, completion: nil)
        
    }
    
    func setData(placeModel: PlaceModel, _ vc: BestViewController){
        imageMain.loadImageWithCache(withUrl: placeModel.imageMainUrl ?? "")
        titlelabel.text = placeModel.title
        
        
        pModel = placeModel
        
        self.parentVC = vc
      
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        
        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
            ] as [NSAttributedString.Key : Any]
        
        let attributedString = NSMutableAttributedString(string: placeModel.shortDescription ?? "", attributes: hyphenAttribute)
        self.shortDescriptionLabel.attributedText = attributedString
        
        
        
        
        guard let type = placeModel.type else{
            backgroundTypeView.isHidden = true
            return
        }
        
        switch type {
        case .culture:
            typeLabel.text = "Культура"
            backgroundTypeView.backgroundColor = UIColor(rgbColorCodeRed: 214, green: 111, blue: 92, alpha: 100)
        case .historical:
            typeLabel.text = "История"
            backgroundTypeView.backgroundColor = UIColor(rgbColorCodeRed: 224, green: 170, blue: 103, alpha: 100)
        case .parks:
            typeLabel.text = "Парки"
            backgroundTypeView.backgroundColor = UIColor(rgbColorCodeRed: 117, green: 201, blue: 114, alpha: 100)
        case .havingFun:
            typeLabel.text = "Отдых"
            backgroundTypeView.backgroundColor = UIColor(rgbColorCodeRed: 110, green: 197, blue: 206, alpha: 100)
        case .eatplaces:
            typeLabel.text = "Еда"
            backgroundTypeView.backgroundColor = UIColor(rgbColorCodeRed: 172, green: 128, blue: 212, alpha: 100)
        case .hotels:
            typeLabel.text = "Отели"
            backgroundTypeView.backgroundColor = UIColor(rgbColorCodeRed: 110, green: 158, blue: 214, alpha: 100)
        }
        
    }
    
    
   
}
