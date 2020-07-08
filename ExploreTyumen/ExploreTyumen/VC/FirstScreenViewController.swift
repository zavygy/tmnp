//
//  FirstScreenViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 12/25/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    var mode:FScreen?
    @IBOutlet weak var imageViewMain: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(mode != nil){
            switch mode{
            case .best?:
                imageViewMain.image = UIImage()
                titleLabel.text = "Лучшее"
                
            case .collections?:
                imageViewMain.image = UIImage()
                titleLabel.text = "Подборки"
                
            case .places?:
                imageViewMain.image = UIImage()
                titleLabel.text = "Места"
            
            case .quests?:
                imageViewMain.image = UIImage()
                titleLabel.text = "Квесты"
                
            default:
                print("default executed")
            }
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func action(_ sender: Any) {
        switch mode{
        case .best?:
            imageViewMain.image = UIImage()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BestViewController") as! BestViewController
            self.present(vc, animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)

            
        case .collections?:
            imageViewMain.image = UIImage()
            titleLabel.text = "Подборки"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OneDayViewController") as! CollectionsViewController
            self.present(vc, animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)

            
        case .places?:
            imageViewMain.image = UIImage()
            titleLabel.text = "Места"
            
        case .quests?:
            imageViewMain.image = UIImage()
            titleLabel.text = "Квесты"
            
        default:
            print("default executed")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


enum FScreen{
    case best
    case collections
    case places
    case quests
}
