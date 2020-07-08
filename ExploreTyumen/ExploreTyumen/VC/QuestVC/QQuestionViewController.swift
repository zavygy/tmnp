//
//  QQuestionViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 1/9/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class QQuestionViewController: UIViewController {
    
    @IBOutlet weak var iconIncView: UIView!
    @IBOutlet weak var iconPlaceView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textOfQuestionLabel: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var incorrectAnswerView: UIView!
    @IBOutlet weak var onceAgainButton: UIButton!
    
    var backModel:BackgroundLayerQuestModel?
    var questModel: QuestModel?
    
    lazy var tyumen = TyumenApp()
    
    var rightAnswerButtonId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectAnswerView.fastFadeOut()
        
        button1.contentMode = .center
        button2.contentMode = .center
        button3.contentMode = .center
        button4.contentMode = .center
        
        button1.layer.cornerRadius = 8
        button2.layer.cornerRadius = 8
        button3.layer.cornerRadius = 8
        button4.layer.cornerRadius = 8

        
        iconPlaceView.asCircle()
        iconPlaceView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        iconPlaceView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        iconPlaceView.layer.shadowRadius = 8
        iconPlaceView.layer.shadowOpacity = 0.5
        iconPlaceView.layer.masksToBounds = false
        
        iconIncView.asCircle()
        iconIncView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        iconIncView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        iconIncView.layer.shadowRadius = 8
        iconIncView.layer.shadowOpacity = 0.5
        iconIncView.layer.masksToBounds = false
        
        textOfQuestionLabel.text = questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].questText
        
        
        rightAnswerButtonId = Int.random(in: 0..<4) + 1
        
        onceAgainButton.layer.cornerRadius = 20
        
        
        switch rightAnswerButtonId {
        case 1: do{
           
           
                button1.tintColor = UIColor(rgbColorCodeRed: 130, green: 215, blue: 129, alpha: 1)
                button2.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button3.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button4.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
            button1.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].rightAnswer, for: .normal)
            button2.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer1, for: .normal)
            button3.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer2, for: .normal)
            button4.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer3, for: .normal)
            }
        case 2: do{
            
                button1.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button2.tintColor = UIColor(rgbColorCodeRed: 130, green: 215, blue: 129, alpha: 1)
                button3.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button4.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
            button1.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer1, for: .normal)
            button2.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].rightAnswer, for: .normal)
            button3.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer2, for: .normal)
            button4.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer3, for: .normal)
            }
            
        case 3:do{
            
                button1.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button2.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button3.tintColor = UIColor(rgbColorCodeRed: 130, green: 215, blue: 129, alpha: 1)
                button4.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
            button1.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer1, for: .normal)
            button2.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer2, for: .normal)
            button3.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].rightAnswer, for: .normal)
            button4.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer3, for: .normal)
            }
            
            
        case 4:do{
            
                button1.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button2.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button3.tintColor = UIColor(rgbColorCodeRed: 238, green: 131, blue: 106, alpha: 1)
                button4.tintColor = UIColor(rgbColorCodeRed: 130, green: 215, blue: 129, alpha: 1)
            button1.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer1, for: .normal)
            button2.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer2, for: .normal)
            button3.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].answer3, for: .normal)
            button4.setTitle(questModel?.questionToPlaces![(backModel?.placePositionInQuest)!].rightAnswer, for: .normal)
            }
        default:
            return
        }
        
    }
    
    @IBAction func click1(_ sender: Any) {
        ifButtonCorrect(1)
    }
    
    @IBAction func click2(_ sender: Any) {
        ifButtonCorrect(2)
        
    }
    
    @IBAction func click3(_ sender: Any) {
        ifButtonCorrect(3)
        
    }
    
    @IBAction func click4(_ sender: Any) {
        ifButtonCorrect(4)
        
    }
    
    
    func ifButtonCorrect(_ buttonId: Int){
        if(buttonId != rightAnswerButtonId){
            incorrectAnswerView.fastFadeIn()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QAfterQuestionViewController") as! QAfterQuestionViewController
            
            vc.backModel = backModel
            vc.questModel = questModel
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onceAgainAction(_ sender: Any) {
        incorrectAnswerView.fastFadeOut()
    }
}
