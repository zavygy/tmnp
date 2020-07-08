//
//  QuestFullModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 17/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation

class QuestModel{
    var title: String?
    var subtitle: String?
    var imageMainUrl: String?
    var description1: String?
    var description2: String?
    var placesForQuests:[Int]?
    var descriptionForPlaces:[QDescriptionModel]?
    var questionToPlaces:[QuestionForPlace]?
    var beginCoordinates: CLLocationCoordinate2D?
    var dateFinish:Date?
    var images:[UIImage]?
    var timeToComplete: String?
    var distToComplete: String?
    var uniqueQuestId: Int?
    
    var stats: [QuestStatisticModel]?
    
    init(title: String, subtitle: String = "", description1: String, description2: String, imageMainUrl: String, startCoor: CLLocationCoordinate2D, places: [Int], descForPlaces: [QDescriptionModel], questToPlaces:[QuestionForPlace], stats: [QuestStatisticModel] ,images: [UIImage], id: Int) {
        self.title = title
        self.subtitle = subtitle
        self.imageMainUrl = imageMainUrl
        self.description1 = description1
        self.description2 = description2
        self.placesForQuests = places
        self.descriptionForPlaces = descForPlaces
        self.beginCoordinates = startCoor
        self.questionToPlaces = questToPlaces
        self.images = images
        self.uniqueQuestId = id
        
        self.stats = stats
    }
    
    init() {}
}
