//
//  BackgroundLayerQuestModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 22/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

//import Foundation


class BackgroundLayerQuestModel{
    var allPlacesInQuest:Int?
    var placePositionInQuest: Int?
    
    init(allPlacesInQuest: Int, placePositionInQuest: Int) {
        self.placePositionInQuest = placePositionInQuest
        self.allPlacesInQuest = allPlacesInQuest
        
    }
    
    init() {}
}
