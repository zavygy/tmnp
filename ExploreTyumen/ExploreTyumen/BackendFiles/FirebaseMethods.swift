//
//  FirebaseMethods.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 12/4/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

let imageCache = NSCache<AnyObject, AnyObject>()

//var placeCount: Int = 0
//let placeCache = NSCache<AnyObject, AnyObject>()


class FBMethods{
    
    var mainReference: DatabaseReference!
    
    init() {
        mainReference = Database.database().reference()
    }
    
    func getAllHistories(completion: @escaping([DeepIntoHistoryModel], Bool) -> Void){
        var allHistories:[DeepIntoHistoryModel] = []
        
        
        
        if(Connectivity.isConnectedToInternet){
            
            mainReference.child("preferences").observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as! NSDictionary
                
                let showHistories = value["showHistories"] as? Bool ?? false
                if(!showHistories){
                    completion([], false)
                }else{
                    self.mainReference.child("histories").observeSingleEvent(of: .value, with: {(snapshot) in
                        for child in snapshot.children{
                            let data = child as? DataSnapshot
                            let value = data?.value as! NSDictionary
                            
                            let id = value["id"] as? Int ?? 0
                            let d1 = value["description1"] as? String ?? ""
                            let d2 = value["description2"] as? String ?? ""
                            let imageUrl = value["mainImageUrl"] as? String ?? ""
                            
                            var photosUrl:[String] = []
                            
                            
                            let photos = data?.childSnapshot(forPath: "photosUrl")
                            
                            for i in (photos?.children)!{
                                let photosData = i as? DataSnapshot
                                let photosValue = photosData?.value as! NSDictionary
                                
                                let photoUrl = photosValue["url"] as? String ?? ""
                                photosUrl.append(photoUrl)
                            }
                            
                            
                            
                            
                            
                            
                            let histModel = DeepIntoHistoryModel(id: id, d1, d2, imageUrl: imageUrl, photosUrl: photosUrl)
                            
                            allHistories.append(histModel)
                            
                        }
                        completion(allHistories, false)
                    }){(error) in
                        completion([], true)
                    }
                }
                
            })
            
        }else{
            completion([], true)
        }
        
    }
    
    func getAllPlaces(completion: @escaping([PlaceModel], Bool) -> Void){
        var allPlaces:[PlaceModel] = []
        
        
        if(Connectivity.isConnectedToInternet){
            mainReference.child("places").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children{
                    
                    
                    let data = child as? DataSnapshot
                    let value = data?.value as! NSDictionary
                    
                    let title:String = value["title"] as? String ?? ""
                    let discription:String = value["description"] as? String ?? ""
                    let adress: String = value["address"] as? String ?? ""
                    let latitude: Double = value["lat"] as? Double ?? 0
                    let longitude: Double = value["lon"] as? Double ?? 0
                    let uniqueId: Int = value["id"] as? Int ?? -1
                    
                    let willNotBeShownToUser: String = value["willNotBeShownToUser"] as? String ?? "false"
                    
                    if(willNotBeShownToUser == "false"){
                        
                        let subtitle: String? = value["subtitle"] as? String ?? nil
                        
                        let typeplaceData: Int = value["type"] as? Int ?? 0
                        
                        var type: PlaceClassification = .historical
                        
                        switch(typeplaceData){
                        case 0:
                            type = .culture
                        case 1:
                            type = .historical
                        case 2:
                            type = .parks
                        case 3:
                            type = .havingFun
                        case 4:
                            type = .eatplaces
                        case 5:
                            type = .hotels
                        default:
                            type = .havingFun
                        }
                        
                        let imageUrl = value["mainImageUrl"] as? String ?? nil
                        
                        
                        let includePhotos:String = value["includePhotos"] as? String ?? ""
                        
                        
                        var photosUrl:[String] = []
                        
                        
                        let ttType = value["tTAllDay"] as? String ?? ""
                        
                        
                        
                        let tt = TimeTableModel()
                        
                        let timetable = data?.childSnapshot(forPath: "timeTable")
                        let timetableData = timetable as? DataSnapshot
                        let timetableValue = timetableData?.value as! NSDictionary
                        
                        
                        
                        let timeMonday = timetableValue["mon"] as! String
                        let timeTuesday = timetableValue["tue"] as! String
                        let timeWednesday = timetableValue["wed"] as! String
                        let timeThursday = timetableValue["thu"] as! String
                        let timeFriday = timetableValue["fri"] as! String
                        let timeSaturday = timetableValue["sat"] as! String
                        let timeSunday = timetableValue["sun"] as! String
                        
                        tt.mondayTime = timeMonday
                        tt.tuesdayTime = timeTuesday
                        tt.wednesdayTime = timeWednesday
                        tt.thursdayTime = timeThursday
                        tt.fridayTime = timeFriday
                        tt.saturdayTime = timeSaturday
                        tt.sundayTime = timeSunday
                        
                        
                        
                        if(includePhotos == "true"){
                            let photos = data?.childSnapshot(forPath: "photosUrl")
                            
                            for i in (photos?.children)!{
                                let photosData = i as? DataSnapshot
                                let photosValue = photosData?.value as! NSDictionary
                                
                                let photoUrl = photosValue["url"] as? String ?? ""
                                photosUrl.append(photoUrl)
                            }
                            
                            let placeModel = PlaceModel(title: title, shortDescription: discription, imageMainUrl: imageUrl!, photos: photosUrl, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), adress: adress, type: type, id: uniqueId)
                            placeModel.includePhotos = true
                            placeModel.timeTable = tt
                            if(subtitle != nil){
                                placeModel.subtitle = subtitle
                            }
                            if(ttType == "true"){
                                placeModel.allDay = true
                            }
                            allPlaces.append(placeModel)
                        }else{
                            let placeModel = PlaceModel(title: title, shortDescription: discription, imageMainUrl: imageUrl!, photos: [], location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), adress: adress, type: type, id: uniqueId)
                            placeModel.timeTable = tt
                            if(subtitle != nil){
                                placeModel.subtitle = subtitle
                            }
                            if(ttType == "true"){
                                placeModel.allDay = true
                            }
                            allPlaces.append(placeModel)
                        }
                        
                    }
                    
                    
                    
                }
                completion(allPlaces, false)
            }) { (error) in
                print(error)
                completion([], true)
            }
            
        }else{
            completion([], true)
        }
        
    }
    
    
    func getAllFacts(complition: @escaping([InterestingFactModel]) -> Void){
        var allFacts:[InterestingFactModel] = []
        if(Connectivity.isConnectedToInternet){
            mainReference.child("facts").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children{
                    let data = child as? DataSnapshot
                    let value = data?.value as! NSDictionary
                    
                    
                    let id = value["placeId"] as? Int ?? 0
                    let fact = value["fact"] as? String ?? ""
                    
                    
                    
                    let model = InterestingFactModel(id: id, fact: fact)
                    allFacts.append(model)
                }
                complition(allFacts)
            }){(error) in
                print(error)
            }
        }
        
    }
    
    func getAllCollections(complition: @escaping([CollectionModel], Bool) -> Void){
        var allCollections:[CollectionModel] = []
        
        if(Connectivity.isConnectedToInternet){
            mainReference.child("collections").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children{
                    let data = child as? DataSnapshot
                    let value = data?.value as! NSDictionary
                    
                    let title = value["title"] as? String ?? ""
                    let shDescription = value["shortDescription"] as? String ?? ""
                    
                    let placesString = value["placesIdString"] as? String ?? ""
                    let imageUrl = value["imageMainUrl"] as? String ?? ""
                    let id = value["id"] as? Int ?? 0
                    
                    
                    let delimeter = ";"
                    let mP = placesString.components(separatedBy: delimeter)
                    
                    var massiveOfPlaces:[Int] = []
                    
                    for i in mP{
                        massiveOfPlaces.append(Int(i) ?? 0)
                    }
                    
                    let model = CollectionModel(title: title, imageUrl: imageUrl ,shortDescription: shDescription, places: massiveOfPlaces, id: id)
                    allCollections.append(model)
                }
                complition(allCollections, false)
            }){(error) in
                print(error)
                complition([], true)
            }
            
        }else{
            complition([], true)
        }
        
    }
    
    func getAllQuests(complition: @escaping([QuestModel], Bool) -> Void){
        var allQuests:[QuestModel] = []
        
        if(Connectivity.isConnectedToInternet){
            mainReference.child("quests").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children{
                    let data = child as? DataSnapshot
                    let value = data?.value as! NSDictionary
                    
                    let title = value["title"] as? String ?? ""
                    let subtitlet = value["subtitle"] as? String ?? ""
                    let desc1 = value["desc1"] as? String ?? ""
                    let desc2 = value["desc2"] as? String ?? ""
                    let id = value["id"] as? Int ?? 0
                    let imageUrl = value["imageMainUrl"] as? String ?? ""
                    let placesString = value["places"] as? String ?? ""
                    let dateString = value["finishDate"] as? String ?? ""
                    let distance = value["distance"] as? String ?? ""
                    let time = value["time"] as? String ?? ""
                    let willNotBeShownToUser = value["willNotBeShownToUser"] as? String ?? ""
                    
                    let delimeter = ";"
                    let mP = placesString.components(separatedBy: delimeter)
                    
                    var massiveOfPlaces:[Int] = []
                    
                    for i in mP{
                        massiveOfPlaces.append(Int(i) ?? 0)
                    }
                    
                    
                    
                    var allQuestions:[QuestionForPlace] = []
                    
                    
                    var stats:[QuestStatisticModel] = []
                    
                    
                    let statData = data?.childSnapshot(forPath: "stats") as! DataSnapshot
                    
                    for i in statData.children{
                        let dataStat = i as? DataSnapshot
                        let valueStat = dataStat?.value as! NSDictionary
                        
                        let val = valueStat["val"] as? String ?? ""
                        let desc = valueStat["desc"] as? String ?? ""
                        
                        let m = QuestStatisticModel(value: val, description: desc)
                        
                        stats.append(m)
                    }
                    
                    let questionsData = data?.childSnapshot(forPath: "questions") as! DataSnapshot
                    let descriptionsData = data?.childSnapshot(forPath: "decriptionsForPlaces") as! DataSnapshot
                    
                    
                    for i in questionsData.children{
                        let dataQ = i as? DataSnapshot
                        let valueQ = dataQ?.value as! NSDictionary
                        let text = valueQ["text"] as? String ?? ""
                        let answ1 = valueQ["answ1"] as? String ?? ""
                        let answ2 = valueQ["answ2"] as? String ?? ""
                        let answ3 = valueQ["answ3"] as? String ?? ""
                        let rightAnswer = valueQ["rightAnsw"] as? String ?? ""
                        
                        let qModel = QuestionForPlace(text: text, answ1: answ1, answ2: answ2, answ3: answ3, rightAnsw: rightAnswer)
                        allQuestions.append(qModel)
                    }
                    
                    var descriptions:[QDescriptionModel] = []
                    
                    for i in descriptionsData.children{
                        let dataD = i as? DataSnapshot
                        let valueD = dataD?.value as! NSDictionary
                        let firstD = valueD["fPart"] as? String ?? ""
                        let secondD = valueD["sPart"] as? String ?? ""
                        let imageUrl = valueD["imageUrl"] as? String ?? "nil"
                        
                        if(imageUrl != "nil"){
                            let modelD = QDescriptionModel(firstDescrp: firstD, secDescrp: secondD, imageUrl: imageUrl)
                            descriptions.append(modelD)
                        }else{
                            let modelD = QDescriptionModel(firstDescrp: firstD, secDescrp: secondD, imageUrl: nil)
                            descriptions.append(modelD)
                        }
                        
                        
                    }
                    
                    
                    
                    let model = QuestModel(title: title, subtitle: subtitlet, description1: desc1, description2: desc2, imageMainUrl: imageUrl, startCoor: CLLocationCoordinate2D(latitude: 50.0, longitude: 50.0), places: massiveOfPlaces, descForPlaces: descriptions, questToPlaces: allQuestions, stats: stats ,images: [],id: id)
                    
                    model.timeToComplete = time
                    model.distToComplete = distance
                    
                    if(dateString != ""){
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        
                        let date = dateFormatter.date(from: dateString)
                        
                        model.dateFinish = date
                    }
                    
                    if(willNotBeShownToUser != "true"){
                        allQuests.append(model)
                    }
                }
                complition(allQuests, false)
            }){(error) in
                print(error)
                complition([], true)
            }
            
        }else{
            complition([], true)
        }
    }
    
    
    func getAllBests(complition: @escaping([BestCardIntroModel], Bool) -> Void){
        
        var massiveOfCards:[BestCardIntroModel] = []
        
        if(Connectivity.isConnectedToInternet){
            mainReference.child("bests").observeSingleEvent(of: .value, with: {(snapshot) in
                
                for i in snapshot.children{
                    let data  = i as? DataSnapshot
                    let value = data?.value as! NSDictionary
                    
                    let title = value["title"] as? String ?? ""
                    let description = value["description"] as? String ?? ""
                    let placesString = value["places"] as? String ?? ""
                    let subtitle = value["subtitle"] as? String ?? ""
                    
                    let imageMainUrl = value["imageMainUrl"] as? String ?? ""
                    
                    
                    
                    let delimetr = ";"
                    var massivePlaces:[Int] = []
                    
                    
                    let mP = placesString.components(separatedBy: delimetr)
                    
                    for k in mP{
                        massivePlaces.append(Int(k) ?? 0)
                    }
                    
                    
                    let m = BestCardIntroModel(title: title, description: description, subtitle: subtitle, placesId: massivePlaces, imageMainUrl: imageMainUrl)
                    
                    massiveOfCards.append(m)
                }
                
                complition(massiveOfCards, false)
            }){(error) in
                print(error)
                complition([], true)
            }
        }else{
            complition([], true)
        }
    }
    
    

    func loadImageWithCache(withUrl: String, returning: @escaping(UIImage) -> Void){
        
        if let cachedImage = imageCache.object(forKey: withUrl as AnyObject) as? UIImage{
            returning(cachedImage)
            return
        }
        
        
        let url = URL(string: withUrl)
        if(url != nil){
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if(error != nil){
                    print(error)
                }
                
                
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: withUrl as AnyObject)
                    returning(downloadedImage)
                }
                
                
            }).resume()
        }
        
        
    }
    
    
    
   
    
    
}
