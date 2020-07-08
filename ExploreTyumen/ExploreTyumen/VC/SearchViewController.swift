//
//  SearchViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 12/22/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchField: ImageTextField!
    @IBOutlet weak var collectionViewResults: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    
    
    var searchedArrayPlace:[PlaceModel] = []
    var searchedArrayQuest:[QuestModel] = []
    var searchedArrayCollections:[CollectionModel] = []
    
    
    lazy var tyumen = TyumenApp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewResults.fastFadeOut()
        
        closeButton.layer.cornerRadius = 20
        
        
        self.hideKeyboardWhenTappedAround()
        
        collectionViewResults.register(UINib.init(nibName: "QuestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuestCollectionViewCell")
        
        collectionViewResults.register(UINib.init(nibName: "PlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCollectionViewCell")
        
        collectionViewResults.register(UINib.init(nibName: "CollectiongroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectiongroupCollectionViewCell")
        
        searchField.delegate = self
        
        searchField.addTarget(self, action: #selector(searchRecordsAsPerText(_:)), for: .editingChanged)
        
        
        
        tyumen.fillPlaces(escaping: {(success1) in
            if(success1){
                
                        self.tyumen.fillCollections(escaping: {(success3) in
                            if(success3){
                                self.collectionViewResults.delegate = self
                                self.collectionViewResults.dataSource = self
                                
                            }
                        })
                
            }
        })
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func searchRecordsAsPerText(_ textField: UITextField) {
        if(textField.text?.characters.count != 0){
            searchedArrayPlace = []
            searchedArrayCollections = []
            
            for place in tyumen.places{
                let range = (place.title ?? "").lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                
                
                if(range != nil){
                    searchedArrayPlace.append(place)
                }
            }
            
          
            
            for collection in tyumen.collections{
                let range = collection.title.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                
                
                if(range != nil){
                    searchedArrayCollections.append(collection)
                }
            }
            collectionViewResults.reloadData()
            collectionViewResults.fastFadeIn()
        }else{
            collectionViewResults.fastFadeOut()
        }
        
        
    }
    
    
    
    
    
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedArrayPlace.count + searchedArrayCollections.count + searchedArrayQuest.count
    }
    
    // first - quest
    // second - collection
    // third - place
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.row < searchedArrayQuest.count){
            let cell = collectionViewResults.dequeueReusableCell(withReuseIdentifier: "QuestCollectionViewCell", for: indexPath) as! QuestCollectionViewCell
            
            cell.setData(searchedArrayQuest[indexPath.row])
            
            return cell
        }else if(indexPath.row < (searchedArrayCollections.count + searchedArrayQuest.count)){
            let cell = collectionViewResults.dequeueReusableCell(withReuseIdentifier: "CollectiongroupCollectionViewCell", for: indexPath) as! CollectiongroupCollectionViewCell
            
            cell.setData(model: searchedArrayCollections[indexPath.row - searchedArrayQuest.count])
            
            return cell
        }else{
            let cell = collectionViewResults.dequeueReusableCell(withReuseIdentifier: "PlaceCollectionViewCell", for: indexPath) as! PlaceCollectionViewCell
            
            cell.setData(searchedArrayPlace[indexPath.row - searchedArrayQuest.count - searchedArrayCollections.count], nil)
            
            
            cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 8
            cell.layer.shadowOpacity = 0.6
            cell.layer.masksToBounds = false
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row < searchedArrayQuest.count){
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestDetailedViewController") as! QuestDetailedViewController
            
            vc.questFullModel = searchedArrayQuest[indexPath.row]
            
            self.present(vc, animated: true, completion: nil)
            
        }else if(indexPath.row < (searchedArrayCollections.count + searchedArrayQuest.count)){
            let storyboard = UIStoryboard(name: "DetailedCollection", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailedCollectionViewController") as! DetailedCollectionViewController
            
            vc.collectionModel = searchedArrayCollections[indexPath.row - searchedArrayQuest.count]
            
            self.present(vc, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
            
            vc.placeFullModel = searchedArrayPlace[indexPath.row - searchedArrayQuest.count - searchedArrayCollections.count]
            
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row < searchedArrayQuest.count){
            let width = collectionView.layer.frame.width - 24
            let heigth:CGFloat = 130
            return CGSize(width: width, height: heigth)
            
        }else if(indexPath.row < searchedArrayCollections.count + searchedArrayQuest.count){
            let width = collectionView.frame.width - 24
            return CGSize(width: width, height: 120)
            
        }else{
            let width = collectionView.layer.frame.width - 24
            let heigth:CGFloat = 111
            return CGSize(width: width, height: heigth)
            
        }
    }
    
    
}
