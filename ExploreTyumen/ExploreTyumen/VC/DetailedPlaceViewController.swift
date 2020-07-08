//
//  DetailedPlaceViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 21/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import MapKitGoogleStyler

class DetailedPlaceViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typePlaceLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var openInMapsButton: UIButton!
    @IBOutlet weak var interestingFactLabel: UILabel!
    @IBOutlet weak var viewInterestingFact: UIView!
    @IBOutlet weak var loadingViewBackground: UIView!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var isOpenTodayLabel: UILabel!
    
    
    @IBOutlet weak var labelMonday: UILabel!
    @IBOutlet weak var labelTuesday: UILabel!
    @IBOutlet weak var labelWednesday: UILabel!
    @IBOutlet weak var labelThursaday: UILabel!
    @IBOutlet weak var labelFriday: UILabel!
    @IBOutlet weak var labelSaturday: UILabel!
    @IBOutlet weak var labelSunday: UILabel!
    
    @IBOutlet weak var isOpenTodayView: UIView!
    
    
    @IBOutlet weak var sameCollectionView: UICollectionView!
    
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    @IBOutlet weak var closeActionView: UIView!
    
    
    
    @IBOutlet weak var histPlaceNameLabel: UILabel!
    @IBOutlet weak var histImageView: LoadingImageView!
    @IBOutlet weak var histReadButton: UIButton!
    var histModel: DeepIntoHistoryModel?
    @IBOutlet weak var histViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var histView: UIView!
    
    
    var placeFullModel:PlaceModel?
    
    var initloc:CLLocation?
    let regionRadius: CLLocationDistance = 300
    
    lazy var tyumen = TyumenApp()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    var placeSameArray:[PlaceModel] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePlaceLabel.fadeOut()
        
        
        if(placeFullModel!.allDay == true){
            isOpenTodayLabel.text = "Открыто круглосуточно"
        }else{
            
            switch(Date().dayOfWeek()!){
            case "Понедельник":
                isOpenTodayLabel.text = "Сегодня: \(placeFullModel!.timeTable!.mondayTime!)"
            case "Вторник":
                isOpenTodayLabel.text = "Сегодня: \(placeFullModel!.timeTable!.tuesdayTime!)"
                
            case "Среда":
                isOpenTodayLabel.text = "Сегодня: \(placeFullModel!.timeTable!.wednesdayTime!)"
                
            case "Четверг":
                isOpenTodayLabel.text = "Сегодня: \(placeFullModel!.timeTable!.thursdayTime!)"
            case "Пятница":
                isOpenTodayLabel.text = "Сегодня: \(placeFullModel!.timeTable!.fridayTime!)"
            case "Суббота":
                isOpenTodayLabel.text = "Сегодня: \(placeFullModel!.timeTable!.saturdayTime!)"
            case "Воскресенье":
                isOpenTodayLabel.text = "Сегодня: \(placeFullModel!.timeTable!.sundayTime!)"
            default:
                isOpenTodayLabel.text = "Сегодня неработает"
            }
            
        }
        
        viewInterestingFact.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        viewInterestingFact.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        viewInterestingFact.layer.shadowRadius = 10
        viewInterestingFact.layer.shadowOpacity = 0.6
        viewInterestingFact.layer.masksToBounds = false
        
        placeNameLabel.text = placeFullModel?.title ?? ""
        
        activityIndic.startAnimating()
        
        sameCollectionView.register(UINib.init(nibName: "BestCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestCategoriesCollectionViewCell")
        
        collectionViewPhotos.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
        
        
        collectionViewPhotos.delegate = self
        collectionViewPhotos.dataSource = self
        collectionViewPhotos.reloadData()
        
        labelMonday.text = "ПН   \(placeFullModel!.timeTable!.mondayTime!)"
        labelTuesday.text = "ВТ   \(placeFullModel!.timeTable!.tuesdayTime!)"
        labelWednesday.text = "СР   \(placeFullModel!.timeTable!.wednesdayTime!)"
        labelThursaday.text = "ЧТ   \(placeFullModel!.timeTable!.thursdayTime!)"
        labelFriday.text = "ПТ   \(placeFullModel!.timeTable!.fridayTime!)"
        labelSaturday.text = "СБ   \(placeFullModel!.timeTable!.saturdayTime!)"
        labelSunday.text = "ВС   \(placeFullModel!.timeTable!.sundayTime!)"
        
        
        scrollView.delegate = self
        
        
        loadSamePlaces()
    }
    
    
    func loadSamePlaces(){
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                
                for i in self.tyumen.getListCurrentType(of: [self.placeFullModel!.type!]) ?? []{
                    if(i.uniqueId != self.placeFullModel?.uniqueId && i.uniqueId != ((self.placeFullModel?.uniqueId)!+1)){
                        self.placeSameArray.append(i)
                    }
                }
                
                self.sameCollectionView.delegate = self
                self.sameCollectionView.dataSource = self
                
                self.sameCollectionView.reloadData()
                
                
                
            }
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        tyumen.fillFacts(escaping: {(success) in
            if(success){
                for i in self.tyumen.interestFacts{
                    if(i.id == self.placeFullModel?.uniqueId ?? 0){
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.hyphenationFactor = 1.0
                        
                        let hyphenAttribute = [
                            NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 16)] as [NSAttributedString.Key : Any]
                        
                        let attributedString = NSMutableAttributedString(string: (i.interestingFact ?? ""), attributes: hyphenAttribute)
                        
                        self.interestingFactLabel.attributedText = attributedString
                    }
                }
                
                
                self.tyumen.fillHistories(escaping: {(suc) in
                    if(suc){
                        self.histModel = self.tyumen.getFullHistories(byId: self.placeFullModel?.uniqueId ?? 0)
                        if(self.histModel != nil){
                            self.histPlaceNameLabel.text = self.placeFullModel?.title
                            self.histImageView.loadBlurImageWithCache(withUrl: self.histModel?.imageMainUrl ?? "")
                            
                            self.histReadButton.backgroundColor = .clear
                            self.histReadButton.layer.cornerRadius = 5
                            self.histReadButton.layer.borderWidth = 1
                            self.histReadButton.layer.borderColor = UIColor.white.cgColor
                            self.histViewHeight.constant = 180
                            
                        }else{
                            self.histViewHeight.constant = 0
                        }
                    }else{
                        self.histViewHeight.constant = 0
                    }
                })
                
                if(self.interestingFactLabel.text == ""){
                    let constraint = NSLayoutConstraint(item: self.viewInterestingFact, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
                    self.viewInterestingFact.addConstraint(constraint)
                }
                self.activityIndic.fadeOut()
                self.loadingViewBackground.fadeOut()
                
                
                self.typePlaceLabel.fadeIn()
            }
        })
        
        
        
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(DetailedPlaceViewController.quickActionsButtonTapped(gesture:)))
        
        closeActionView.addGestureRecognizer(tapGesture1)
        
        openInMapsButton.backgroundColor = .clear
        openInMapsButton.layer.cornerRadius = 5
        openInMapsButton.layer.borderWidth = 1
        openInMapsButton.layer.borderColor = UIColor.white.cgColor
        
        initloc = CLLocation(latitude: placeFullModel!.location!.latitude, longitude: placeFullModel!.location!.longitude)
        
        
        centerMapOnLocation(location: initloc ?? CLLocation())
        
        let placePoint = PlacePoint(title: placeFullModel!.title!, locationName: placeFullModel!.title!, coordinate: placeFullModel?.location ?? CLLocationCoordinate2D())
        
        
        
        
        mapView.delegate = self
        
        mapView.addAnnotation(placePoint)
        
        configureTileOverlay()
        
        mapView.showsCompass = false
        mapView.showsScale = false
        setData()
    }
    
    
    @objc func quickActionsButtonTapped(gesture: UIGestureRecognizer){
        if(gesture.view == closeActionView){
            closeActionView.alpha = 1
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    @IBAction func openInMaps(_ sender: Any) {
        let coordintes = CLLocationCoordinate2DMake(placeFullModel!.location!.latitude, placeFullModel!.location!.longitude)
        
        let regionSpan =  MKCoordinateRegion(center: coordintes, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        let placemark = MKPlacemark(coordinate: coordintes, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeFullModel!.title!
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)
            ] as [String : Any])
    }
    
    
    
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "mapStyleRetro", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.addOverlay(tileOverlay)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    func setData(){
        placeNameLabel.text = placeFullModel!.title!
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        
        paragraphStyle.lineSpacing = 1.5
        
        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 17)] as [NSAttributedString.Key : Any]
        
        let attributedString = NSMutableAttributedString(string: (placeFullModel!.shortDescription!), attributes: hyphenAttribute)
        
        descriptionLabel.attributedText = attributedString
        
        
        
        
        
        adressLabel.text = placeFullModel!.adress!
        
        if(placeFullModel?.type != nil){
            let type = placeFullModel!.type!
            
            switch(type){
            case .culture:
                typePlaceLabel.text = "Культура"
                typePlaceLabel.textColor = UIColor(rgbColorCodeRed: 214, green: 111, blue: 92, alpha: 100)
            case .historical:
                typePlaceLabel.text = "История"
                typePlaceLabel.textColor = UIColor(rgbColorCodeRed: 224, green: 170, blue: 103, alpha: 100)
            case .parks:
                typePlaceLabel.text = "Парки"
                typePlaceLabel.textColor = UIColor(rgbColorCodeRed: 117, green: 201, blue: 114, alpha: 100)
            case .havingFun:
                typePlaceLabel.text = "Отдых"
                typePlaceLabel.textColor = UIColor(rgbColorCodeRed: 110, green: 197, blue: 206, alpha: 100)
            case .eatplaces:
                typePlaceLabel.text = "Еда"
                typePlaceLabel.textColor = UIColor(rgbColorCodeRed: 172, green: 128, blue: 212, alpha: 100)
            case .hotels:
                typePlaceLabel.text = "Отели"
                typePlaceLabel.textColor = UIColor(rgbColorCodeRed: 110, green: 158, blue: 214, alpha: 100)
                
            }
        }
        
        if(placeFullModel?.subtitle != nil){
            subtitleLabel.text = placeFullModel?.subtitle
        }
    }
    
    
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {
        
        let size = CGSize(width: view.frame.width - 50, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        return rectangleHeight
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        guard let link = URL(string: "https://exploretyumen.page.link/places/\(placeFullModel?.uniqueId ?? 0)") else { return }
        let dynamicLinksDomain = "exploretyumen.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domain: dynamicLinksDomain)
        
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "GlebZavyalov.Tyumen")
        linkBuilder.iOSParameters?.appStoreID = "1434976996"
        linkBuilder.iOSParameters?.minimumAppVersion = "1.0"
        
        
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "\(placeFullModel?.title ?? "")"
        linkBuilder.socialMetaTagParameters?.descriptionText = "\(placeFullModel?.shortDescription ?? "")"
        
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: placeFullModel?.imageMainUrl ?? "")
        
        let textToAppend = "Откройте для себя: \(placeFullModel?.title ?? "")"
        
        
        
        
        
        linkBuilder.shorten(completion: {(shortUrl, warns, error) in
            if let err = error{
                print(err)
                return
            }
            let objectToShare = [textToAppend, shortUrl!] as [Any]
            
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            
            
            activityVC.popoverPresentationController?.sourceView = sender as! UIView
            self.present(activityVC, animated: true, completion: nil)
        })
        
        
        
        
        
    }
    
    
}


extension DetailedPlaceViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? PlacePoint else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            
            switch(placeFullModel!.type!){
            case .culture:
                view.markerTintColor = UIColor(rgbColorCodeRed: 214, green: 111, blue: 92, alpha: 100)
            case .historical:
                view.markerTintColor = UIColor(rgbColorCodeRed: 224, green: 170, blue: 103, alpha: 100)
            case .parks:
                view.markerTintColor = UIColor(rgbColorCodeRed: 117, green: 201, blue: 114, alpha: 100)
            case .havingFun:
                view.markerTintColor = UIColor(rgbColorCodeRed: 110, green: 197, blue: 206, alpha: 100)
            case .eatplaces:
                view.markerTintColor = UIColor(rgbColorCodeRed: 172, green: 128, blue: 212, alpha: 100)
            case .hotels:
                view.markerTintColor = UIColor(rgbColorCodeRed: 110, green: 158, blue: 214, alpha: 100)
                
            }
            
            
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinate = CLLocationCoordinate2DMake(placeFullModel!.location!.latitude, placeFullModel!.location!.longitude)
        var span = mapView.region.span
        if span.latitudeDelta < 0.002 { // MIN LEVEL
            span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        } else if span.latitudeDelta > 0.005 { // MAX LEVEL
            span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.005)
        }
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
        
        
        
    }
    
    
}


extension DetailedPlaceViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == self.scrollView){
            if self.scrollView.isTracking && scrollView.contentOffset.y < -70 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension DetailedPlaceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == collectionViewPhotos){
            pageControl.numberOfPages = (placeFullModel!.photos?.count ?? 0) + 1
            pageControl.currentPage = 0
            return (placeFullModel!.photos?.count ?? 0) + 1
            
        }else{
            return placeSameArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == collectionViewPhotos){
            pageControl.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == collectionViewPhotos){
            if(indexPath.row == 0){
                let cell = collectionViewPhotos.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
                
                cell.setData(placeFullModel!.imageMainUrl!)
                return cell
            }else{
                let cell = collectionViewPhotos.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
                
                cell.setData(placeFullModel!.photos![indexPath.row - 1])
                return cell
            }
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestCategoriesCollectionViewCell", for: indexPath) as! BestCategoriesCollectionViewCell
            
            cell.setData(title: placeSameArray[indexPath.row].title ?? "", imageMainUrl: placeSameArray[indexPath.row].imageMainUrl ?? "", imageMain: UIImage(), categorie: .places)
            
            
            cell.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 10
            cell.layer.shadowOpacity = 0.8
            cell.layer.masksToBounds = false
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView != collectionViewPhotos){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
            
            vc.placeFullModel = placeSameArray[indexPath.row]
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == collectionViewPhotos){
            return CGSize(width: collectionViewPhotos.layer.frame.width, height: collectionViewPhotos.layer.frame.height)
        }else{
            return CGSize(width: 200, height: 115)
        }
    }
    
    
}


