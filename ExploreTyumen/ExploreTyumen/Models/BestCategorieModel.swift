//
//  BestCategorieModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 30/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation


class BestCategorieModel {
    var id: Int
    var categorie: CategorieBestEnum
    init(_ id: Int, _ categorie: CategorieBestEnum){
        self.id = id
        self.categorie = categorie
    }
}
