//
//  File.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 2/16/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import Foundation

class BestCardIntroModel{
    var title: String?
    var subtitle: String?
    var description: String?
    var imageMainUrl: String?
    var placesId: [Int] = []
    
    init(title: String, description: String, subtitle: String, placesId: [Int], imageMainUrl: String) {
        self.title = title
        self.description = description
        self.placesId = placesId
        self.imageMainUrl = imageMainUrl
        self.subtitle = subtitle
    }
}
