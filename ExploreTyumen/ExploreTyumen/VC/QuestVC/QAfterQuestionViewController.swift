//
//  QAfterQuestionViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 1/10/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class QAfterQuestionViewController: UIViewController {
    
    @IBOutlet weak var iconCorrectView: UIView!
    
    var backModel:BackgroundLayerQuestModel?
    var questModel: QuestModel?

    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 20
        iconCorrectView.asCircle()
        
        iconCorrectView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        iconCorrectView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        iconCorrectView.layer.shadowRadius = 8
        iconCorrectView.layer.shadowOpacity = 0.5
        iconCorrectView.layer.masksToBounds = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if(backModel!.allPlacesInQuest! == backModel!.placePositionInQuest! + 1){
            let stb = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = stb.instantiateInitialViewController() as! ViewController
            
            self.present(vc, animated: true, completion: nil)
        }else{
            let bModel = BackgroundLayerQuestModel(allPlacesInQuest: backModel!.allPlacesInQuest!, placePositionInQuest: backModel!.placePositionInQuest! + 1)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestNextPlaceViewController") as! QuestNextPlaceViewController
            
            
            vc.questModel = questModel
            vc.backModel = bModel
            
            self.present(vc, animated: true, completion: nil)
            
            
        }
    }
    
}
