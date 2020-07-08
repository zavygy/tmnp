//
//  ViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 14/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//


// Under a source control


import UIKit
import CoreLocation
import UserNotifications
import CoreSpotlight
import MobileCoreServices
import RealmSwift

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var collectionViewRecomendations: UICollectionView!
    @IBOutlet weak var constraintCollViewHeigth: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var oneDayAction: UIView!
    @IBOutlet weak var bestAction: UIView!
    @IBOutlet weak var questsAction: UIView!
    @IBOutlet weak var placesAction: UIView!
    
    @IBOutlet weak var searchTextField: ImageTextField!
    @IBOutlet weak var widthActions: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var connectivityLabel: UILabel!
    
    var fStart = FirstStartProjects()
    
    
    
    var placeModelFromSpotlight = PlaceModel()
    
    var locationManager: CLLocationManager!
    var currentUserLoc: CLLocationCoordinate2D?
    
    var lastPlace:PlaceModel?
    
    lazy var tyumen = TyumenApp()
    
    
    
    var heigthOfAllCards:CGFloat = 0
    
    private var indexOfCellBeforeDragging = 0
    
    var placesNearby:[PlaceModel]?
    
    var massiveOfTypeOfCards:[StacksCardTypesEnum] = [.nearby, .collections, .interestingFact, .whatToVisit,  .randomCollection] //.nearby,  .interestingFact
    let numberOfCardsStacks = 5

    let spotlightFeatures = SpotlightFeatures()
    
    
    let realm = try! Realm()
    
    
    var modelCardBests: BestCardIntroModel?
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailedPlaceViewController else{
            return
        }
        
        vc.placeFullModel = placeModelFromSpotlight
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fStart = realm.objects(FirstStartProjects.self).first ?? FirstStartProjects()
        
        
        
        let spf = SpotlightFeatures()
        spf.loadSpotlightSearchableResources()
        
        collectionView.register(UINib.init(nibName: "NearUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NearUserCollectionViewCell")
        
        collectionView.register(UINib.init(nibName: "BestPlacesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestPlacesCollectionViewCell")
        
        collectionView.register(UINib.init(nibName: "InterestFactCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestFactCollectionViewCell")
        
        collectionView.register(UINib.init(nibName: "CollectiongroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectiongroupCollectionViewCell")
        
        
        collectionView.register(UINib.init(nibName: "BestsLinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestsLinkCollectionViewCell")
        
        collectionView.register(UINib.init(nibName: "ThingsToDoneMainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ThingsToDoneMainCollectionViewCell")
        
        connectivityLabel.fadeOut()
        
        collectionView.fadeOut()
        progressView.hidesWhenStopped = true
        progressView.startAnimating()
        
        
        
        if(UIScreen.main.nativeBounds.height == 2208 || UIScreen.main.nativeBounds.height == 2688 ){
            widthActions.constant = 340
        }else if(UIScreen.main.nativeBounds.height == 1792.0){
            widthActions.constant = 320
        }else if(UIScreen.main.nativeBounds.height == 2436.0){
            widthActions.constant = 300
        }else{
            widthActions.constant = CGFloat(UIScreen.main.bounds.width - 32)
        }
        
        
        
        
        //
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.quickActionsButtonTapped(gesture:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.quickActionsButtonTapped(gesture:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.quickActionsButtonTapped(gesture:)))
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(ViewController.quickActionsButtonTapped(gesture:)))
        
        let tapGestureSearch = UITapGestureRecognizer(target: self, action: #selector(ViewController.quickActionsButtonTapped(gesture:)))
        
        
        searchTextField.addGestureRecognizer(tapGestureSearch)
        
        oneDayAction.addGestureRecognizer(tapGesture1)
        bestAction.addGestureRecognizer(tapGesture2)
        questsAction.addGestureRecognizer(tapGesture3)
        placesAction.addGestureRecognizer(tapGesture4)
        
        
        heigthOfAllCards = 0
        
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                self.tyumen.fillFacts(escaping: {(sucs) in
                    if(sucs){
                        self.tyumen.fillBests(escaping: {(suc3) in
                            if(suc3){
                                
                                self.modelCardBests = self.tyumen.bestsModels.shuffled()[0]
                                    
                                self.collectionView.delegate = self
                                self.collectionView.dataSource = self
                                
                                
                                
                                DispatchQueue.main.async {
                                    self.constraintCollViewHeigth.constant = self.heigthOfAllCards
                                    self.collectionView.fadeIn()
                                    self.progressView.fadeOut()
                                    self.progressView.stopAnimating()
                                }
                                
                                
                                
                            }
                        })
                        
                        
                    }
                })
                
                
            }else{
                self.connectivityLabel.fadeIn()
                self.progressView.fadeOut()
            }
        })
        
        prepareCards()
        
    }
    
    

    
    func prepareCards(){
        //        Строчка для перемешивания карточек на главном экране
        //        massiveOfTypeOfCards = massiveOfTypeOfCards.shuffled()
        
        
        
        
    }
    
    
    func awakeDetailedPlace(id: Int){
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
                
                let pModel = self.tyumen.getFullPlace(byId: id)
                
                vc.placeFullModel = pModel
                
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    
    @objc func quickActionsButtonTapped(gesture: UIGestureRecognizer){
        if(gesture.view == oneDayAction){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OneDayViewController") as! CollectionsViewController
            self.present(vc, animated: true, completion: nil)
        }else if(gesture.view == bestAction){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BestViewController") as! BestViewController
            self.present(vc, animated: true, completion: nil)
        }else if(gesture.view == questsAction){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestsViewController") as! QuestsViewController
            self.present(vc, animated: true, completion: nil)
        }else if(gesture.view == placesAction){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlacesViewController") as! PlacesViewController
            self.present(vc, animated: true, completion: nil)
        }else if(gesture.view == searchTextField){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
}






extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectionView){
            return numberOfCardsStacks
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionView){
            switch massiveOfTypeOfCards[indexPath.row] {
            case .nearby: do{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearUserCollectionViewCell", for: indexPath) as! NearUserCollectionViewCell
                
                cell.loadCell(self)
                
                cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 10
                cell.layer.shadowOpacity = 0.6
                cell.layer.masksToBounds = false
                
                let h:CGFloat = 111
                
                
                return cell
                }
            case .collections: do{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestPlacesCollectionViewCell", for: indexPath) as! BestPlacesCollectionViewCell
                cell.setData(vcParent: self)
                
                let h:CGFloat = 126
                
                return cell
                }
                
            case .randomCollection: do{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectiongroupCollectionViewCell", for: indexPath) as! CollectiongroupCollectionViewCell
                
                let h: CGFloat = 150
                
                
                
                
                cell.setRandomCollection(vc: self)
                
                return cell
                
                }
            case .interestingFact: do{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestFactCollectionViewCell", for: indexPath) as! InterestFactCollectionViewCell
                
                
                let h: CGFloat = 163
                
                
                
                tyumen.interestFacts.shuffle()
                
                var mas = tyumen.interestFacts
                
                cell.setData(placeModel: tyumen.getFullPlace(byId: mas[0].id ?? 0) ?? PlaceModel() , fact: mas[0].interestingFact ?? "", mainVC: self)
                
                cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 10
                cell.layer.shadowOpacity = 0.6
                cell.layer.masksToBounds = false
                return cell
                }
                
            case .whatToVisit: do{
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThingsToDoneMainCollectionViewCell", for: indexPath) as! ThingsToDoneMainCollectionViewCell
                
                
                let h:CGFloat = 137
                
                
                cell.setData(self)
                
                
                return cell
                
                }
            
            case .bestLink: do{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestsLinkCollectionViewCell", for: indexPath) as! BestsLinkCollectionViewCell
                
                    cell.setData(modelCardBests!)
                
                
                
                    cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
                    cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                    cell.layer.shadowRadius = 10
                    cell.layer.shadowOpacity = 0.6
                    cell.layer.masksToBounds = false
                    return cell
                
                }
            default:
                return UICollectionViewCell()
            }
        }else{
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width:CGFloat = collectionView.layer.bounds.width - 2
        
        switch massiveOfTypeOfCards[indexPath.row] {
        case .nearby:
            heigthOfAllCards += 111 + 14
            return CGSize(width: width, height: 111)
            
        case .whatToVisit:
            heigthOfAllCards += 137 + 14

            return CGSize(width: width, height: 137)
            
        case .interestingFact:
            var hhh:CGFloat = 48 + 8 + 12
            hhh += heightForLable(labelWidth: width - (13+95 + 12 + 13), numberOfLines: 0, labelText: tyumen.interestFacts[0].interestingFact ?? "", labelFont: UIFont(name: "Roboto-Regular", size: 15) ?? UIFont())
            heigthOfAllCards += 163 + 14

            return CGSize(width: width, height: 163)
        case .randomCollection:
            heigthOfAllCards += 150 + 14

            return CGSize(width: width, height: 150)
            
        case .collections:
            heigthOfAllCards += 126 + 14
            return CGSize(width: width, height: 126)
            
        case .bestLink: do{
            var hhh: CGFloat = CGFloat((modelCardBests?.placesId.count ?? 0)*75) + 25 + 5
            hhh += heightForLable(labelWidth: width - 106, numberOfLines: 0, labelText: modelCardBests?.title ?? "", labelFont: UIFont(name: "Roboto-Medium", size: 20) ?? UIFont())
            
            heigthOfAllCards += hhh + 14
            
            return CGSize(width: width, height: hhh)
            }
            
            
            
        default:
            return CGSize(width: width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(massiveOfTypeOfCards[indexPath.row] == .bestLink){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BestViewController") as! BestViewController
            
            self.present(vc, animated: true, completion: nil)
        }else{
            return
        }
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

