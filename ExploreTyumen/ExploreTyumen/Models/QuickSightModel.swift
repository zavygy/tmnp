//
//  QuickSightModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 16/01/2019.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import Foundation


class QuickSightModel{
    var title:String?
    var imageMainUrl:String?
    var part1:String?
    var part2:String?
    var part3:String?
    var photos:[String] = []
    var fact:String?
    var includePhotos:Bool = false
    var includeFact:Bool = false
    var id:Int?
    init(title: String, imageUrl: String, part1: String, part2: String, part3: String, photos:[String], fact: String, id: Int) {
        self.title = title
        self.imageMainUrl = imageUrl
        self.part1 = part1
        self.part2 = part2
        self.part3 = part3
        self.fact = fact
        self.photos = photos
        self.id = id
    }
}
