//
//  QuestDescriptionModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 12/29/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class QDescriptionModel{
    var firstDescription:String?
    var secondDescription:String?
    var imageUrl:String?
    
    init(firstDescrp:String, secDescrp: String, imageUrl: String?) {
        self.firstDescription = firstDescrp
        self.secondDescription = secDescrp
        self.imageUrl = imageUrl
    }

}
