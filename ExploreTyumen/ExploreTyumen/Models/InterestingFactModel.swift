//
//  InterestingFactModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/14/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation

class InterestingFactModel{
    var id: Int?
    var interestingFact: String?
    
    init(id: Int, fact: String) {
        self.id = id
        self.interestingFact = fact
    }
}
