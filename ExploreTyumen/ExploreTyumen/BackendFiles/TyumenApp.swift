//
//  TyumenApp.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 17/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class TyumenApp{
    
    var bestCategorie:[BestCategorieModel] = [BestCategorieModel(0, .places), BestCategorieModel(1, .places), BestCategorieModel(0, .quests), BestCategorieModel(2, .places), BestCategorieModel(3, .places)]
    
    var bestCollections:[Int] = []
    var bestQuests:[Int] = []
    var bestPlaces:[Int] = []


    
    var allQuests:[QuestModel] = []
    
    var places:[PlaceModel] = []

    var quickSights:[QuickSightModel] = []
    
    var interestFacts:[InterestingFactModel] = []
 
    var collections:[CollectionModel] = []
    
    var histories:[DeepIntoHistoryModel] = []
    
    
    
    var bestsModels:[BestCardIntroModel] = []
    
    var placeTypes:[PlaceClassification] = [.culture, .historical,.parks,.havingFun ,.eatplaces, .hotels]
    
    
    var tenThings:[ThingModel] = [ThingModel(title: "Отдых в горячих источниках", text: "В городе и области находится большое количество горячих источников, которые известны своей экзотичностью. Так как в воде, что находится в этих термальных источниках, много минеральных солей, это занятие очень полезно для вашего здоровья.", image: #imageLiteral(resourceName: "gorIstoch.jpg"), sightsAdd: .collections, id: 0), ThingModel(title: "Занятся своим здоровьем", text: "Тюмень - один из медицинских центров мирового уровня, который известен своими современными медицинскими учреждениями и профессиональной медициной, особенно в области нейрохирургии.", image: #imageLiteral(resourceName: "medGorod.jpg"), sightsAdd: .places, id: 0), ThingModel(title: "Изучить и увидеть прекрасную природу Сибири", text: "Всем известно, что Сибирь это природная достопримечательность России и один из самых красивых регионов страны. Так как Тюмень находится на юго-западе Сибири, здесь самый благоприятный и теплый климат - идеально для туризма. Природа Тюменской области - огромная гордость ее жителей.", image: #imageLiteral(resourceName: "prirodaSibiri.jpg"), sightsAdd: .places, id: 0), ThingModel(title: "Посмотреть на исторический центр", text: "В городе находится большое количество архитектурных памятников - деревянные здания, советские и дореволюционные здания. Все они находятся в хорошем состоянии, ведь различные организации часто занимаются реставрацией. Особенно стоит обратить внимание на деревянное зодчество ", image: #imageLiteral(resourceName: "istorGorod.jpg"), sightsAdd: .places, id: 17), ThingModel(title: "Посетить Тюменскую филармонию", text: "Если хотите культурно провести время - посещение филармонии будет хорошим выбором. В филармонии каждую неделю проходит множество концертов классической музыки, русских народных хоров и различные музыкальные фестивали.", image: #imageLiteral(resourceName: "filarmoniya.jpg"), sightsAdd: .places, id: 8), ThingModel(title: "Прогуляться по набережной", text: "Набережная реки Туры - одно из самых популярных и оживленных мест города.  Это самая главная достопримечательность города и обязательна к посещению. Она идеально подходит для прогулок с друзьями и детьми, также здесь очень часто проводятся различные мероприятия.", image: #imageLiteral(resourceName: "nabereznaya.jpg"), sightsAdd: .places, id: 2), ThingModel(title: "Узнать о истории города и области", text: "Посетите пару из многочисленных музеев города - музей Городская Дума, музейный комплекс имени И.Я. Словцова, исторический парк Россия - моя история и множество других - все они интересно и современно рассказывают о истории Тюменской области и России.", image: #imageLiteral(resourceName: "muzei.jpg"), sightsAdd: .places, id: 4),ThingModel(title: "Сходить на театральное представление", text: "В Тюмени есть три популярных театра - Тюменский театр кукол,  Тюменский Драматический театр и молодежный театр Космос. Во всех театрах как дети, так и взрослые найдут для себя множество интересного. Театральные постановки по классическим русским произведениям, русскому народному творчеству, а также исторические и современные истории.", image: #imageLiteral(resourceName: "dramTheatre.jpg"), sightsAdd: .places, id: 3) ,ThingModel(title: "Попробовать местную кухню", text: "Тюменская область - место, где жило и живет большое количество народов и культур, имеющих свою разнообразную и отличную кухню. Город богат на различные заведения с кухнями народов России - устройте себе небольшое гастрономическое путешествие.", image: #imageLiteral(resourceName: "edaa.jpg"), sightsAdd: .places, id: 10), ThingModel(title: "Прокатится на колесе обозрения", text: "Колесо обозрения находится на цветном бульваре - в самом центре города. Оно пережило реконструкцию и теперь колесо оборудовано для круглогодичного использования. С колеса открывается интересный вид. Так как город не имеет большого количества высоких зданий, то в хорошую погоду можно разглядеть его полностью.", image: #imageLiteral(resourceName: "kolesoObozreniya.jpg"), sightsAdd: .places, id: 14)]
    
    
    
    func fillPlaces(escaping: @escaping(Bool) -> Void) {
        let fb = FBMethods()
        fb.getAllPlaces(completion: {massive, error  in
            
            if(error != true){
                self.places = massive
                escaping(true)
            }else{
                escaping(false)
            }
            
        })
    }
    
    func fillHistories(escaping: @escaping(Bool) -> Void){
        let fb = FBMethods()
        fb.getAllHistories(completion: {massive, error in
            if(error){
                escaping(false)
            }else{
                self.histories = massive
                escaping(true)
            }
        })
    }
    
    func fillFacts(escaping: @escaping(Bool) -> Void){
         let fb = FBMethods()
        fb.getAllFacts(complition: {(massive) in
            self.interestFacts = massive
            escaping(true)
        })
    }
    
    func fillCollections(escaping: @escaping(Bool) -> Void){
        let fb = FBMethods()
        fb.getAllCollections(complition: {massive, error in
            if(error != true){
                self.collections = massive
                escaping(true)
            }else{
                escaping(false)
            }
        })
    }
    
    
  
    func fillQuests(escaping: @escaping(Bool) -> Void){
        let fb = FBMethods()
        fb.getAllQuests(complition: {massive, error in
            if(error != true){
                self.allQuests = massive
                escaping(true)
            }else{
                escaping(false)
            }
        })
    }
    
    func fillBests(escaping: @escaping(Bool) -> Void){
        let fb = FBMethods()
        
        fb.getAllBests(complition: {cards, error in
            if(error != true){
                self.bestsModels = cards
                escaping(true)
            }else{
                escaping(false)
            }
        })
    }
    
   
    
    
    func getFullQuest(byId: Int) -> QuestModel? {
        for i in allQuests{
            if(i.uniqueQuestId == byId){
                return i
            }
        }
        return nil
    }
    
    func getFullHistories(byId: Int) -> DeepIntoHistoryModel? {
        for i in histories{
            if(i.id == byId){
                return i
            }
        }
        return nil
    }
    
    func getPlacesNearUser(_ currentUserLocation: CLLocationCoordinate2D) -> [PlaceModel]{
        let userLoc = CLLocation(latitude: currentUserLocation.latitude, longitude: currentUserLocation.longitude)
        
        let sortedPlaces = places.sorted(by: {userLoc.distance(from: CLLocation(latitude: $0.location!.latitude, longitude: $0.location!.longitude) ) < userLoc.distance(from: CLLocation(latitude:  $1.location!.latitude, longitude:  $1.location!.longitude)) })
        
        
        return sortedPlaces
    }
    
    func getFullPlace(byId: Int) -> PlaceModel?{
        for i in places{
            if(i.uniqueId == byId){
                return i
            }
        }
        return nil
    }
    
    func getFullCollection(byId: Int) -> CollectionModel?{
        for i in collections{
            if(i.uniqueId == byId){
                return i
            }
        }
        return nil
    }
    
    
    
    func getListCurrentType(of: [PlaceClassification]) -> [PlaceModel]? {
        var models:[PlaceModel] = []
        for i in places{
            for j in of{
                if(i.type == j){
                    models.append(i)
                }
            }
        }
        return models
        
        
    }
}
