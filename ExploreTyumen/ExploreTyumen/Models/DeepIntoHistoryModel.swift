//
//  DeepIntoHistoryModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 2/13/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import Foundation


class DeepIntoHistoryModel{
    var id: Int?
    var description1: String?
    var imageMainUrl: String?
    var description2: String?
    
    var photosUrl:[String] = []
    
    
    init(){
        
    }
    
    init(id: Int?, _ d1: String, _ d2: String, imageUrl: String?) {
        self.id = id
        self.description1 = d1
        self.description2 = d2
        self.imageMainUrl = imageUrl
    }
    
    
    init(id: Int?, _ d1: String, _ d2: String, imageUrl: String?, photosUrl: [String]) {
        self.id = id
        self.description1 = d1
        self.description2 = d2
        self.imageMainUrl = imageUrl
        self.photosUrl = photosUrl
    }
}
