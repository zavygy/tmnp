//
//  SpotlightFeatures.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/11/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
class SpotlightFeatures {
    lazy var tyumen = TyumenApp()
    
    
    func loadSpotlightSearchableResources(){
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                var searchableItems = [CSSearchableItem]()
                var count = 0
                for match in self.tyumen.places{
                    let searchItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                    searchItemAttributeSet.title = match.title
                    searchItemAttributeSet.contentDescription = match.shortDescription
                    searchItemAttributeSet.thumbnailURL = URL(string: match.imageMainUrl ?? "")
                    
                    
                    
                    let idU = "\(match.uniqueId ?? 0)"
                    
                    let sItem = CSSearchableItem(uniqueIdentifier: idU, domainIdentifier: "matches", attributeSet: searchItemAttributeSet)
                    searchableItems.append(sItem)
                    count+=1
                }
                
                CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
                    if error != nil {
                        print(error?.localizedDescription ?? "Error")
                    }
                }
            }
        })
       
    }
    
    
}

