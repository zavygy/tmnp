//
//  QuestsViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 18/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class QuestsViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var collectionViewQuests: UICollectionView!
    @IBOutlet weak var heigthColView: NSLayoutConstraint!
    @IBOutlet weak var heigthStatusBar: NSLayoutConstraint!
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    @IBOutlet weak var noNetworkLabel: UILabel!

    
    var heigthForCollectionView:CGFloat = 0
    
    lazy var tyumen = TyumenApp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndic.startAnimating()
        self.collectionViewQuests.fadeOut()
        noNetworkLabel.fadeOut()
        heigthStatusBar.constant = UIApplication.shared.statusBarFrame.height
        
        tyumen.fillQuests(escaping: {(success) in
            if(success){
                self.collectionViewQuests.fadeOut()
                self.scrollViewMain.delegate = self
                
                
                self.collectionViewQuests.register(UINib.init(nibName: "QuestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuestCollectionViewCell")
                
                self.collectionViewQuests.delegate = self
                self.collectionViewQuests.dataSource = self
                
                DispatchQueue.main.async {
                     self.heigthColView.constant = self.heigthForCollectionView
                }
                
               
                
                self.activityIndic.stopAnimating()
                self.collectionViewQuests.reloadData()
                self.collectionViewQuests.fadeIn()
                
            }else{
                self.noNetworkLabel.fadeIn()
            }
        })
        
        
        
    }
    
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == scrollViewMain){
            if self.scrollViewMain.isTracking && scrollViewMain.contentOffset.y < -70 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension QuestsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tyumen.allQuests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewQuests.dequeueReusableCell(withReuseIdentifier: "QuestCollectionViewCell", for: indexPath) as! QuestCollectionViewCell
        
        
        cell.setData(tyumen.allQuests[indexPath.row])
        
        
        cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.layer.frame.width
        
        var heigth: CGFloat = 150 + 24
        
        heigth += 23.5 + 6 + 12 + 7
        
        heigth += heightForLable(labelWidth: width - 8 - 12, labelText: tyumen.allQuests[indexPath.row].subtitle ?? "", labelFont: UIFont(name: "Roboto-Regular", size: 17.0)!) + 12
        
        
        
        heigthForCollectionView += heigth + 10
        
        
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mStoryboard = UIStoryboard(name: "QuestDetailed", bundle: nil)
        
        let vc = mStoryboard.instantiateViewController(withIdentifier: "QuestDetailedViewController") as! QuestDetailedViewController
        
        vc.questFullModel = tyumen.allQuests[indexPath.row]
        
        self.present(vc, animated: true, completion: nil)
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

