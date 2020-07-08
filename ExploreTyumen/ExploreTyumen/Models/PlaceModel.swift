//
//  PlaceFullModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 21/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import MapKit

class PlaceModel{
    var title: String?
    var shortDescription: String?
    var imageMain: UIImage?
    var photos:[String]?
    var includePhotos:Bool = false
    var adress: String?
    var subtitle: String? = nil
    var location: CLLocationCoordinate2D?
    var uniqueId: Int?
    var imageMainUrl: String?
    var timeTable: TimeTableModel?
    var allDay: Bool = false
    
    var type: PlaceClassification?
    init(title: String, shortDescription: String, imageMain: UIImage, photos: [String], location: CLLocationCoordinate2D, adress: String, id: Int) {
        self.title = title
        self.shortDescription = shortDescription
        self.imageMain = imageMain
        self.photos = photos
        self.uniqueId = id
        self.adress = adress
        self.location = location
    }
    
    init(title: String, shortDescription: String, imageMain: UIImage, photos: [String], location: CLLocationCoordinate2D, adress: String, type: PlaceClassification ,id: Int) {
        self.title = title
        self.shortDescription = shortDescription
        self.imageMain = imageMain
        self.photos = photos
        self.uniqueId = id
        self.adress = adress
        self.location = location
        self.type = type
    }
    
    init(title: String, shortDescription: String, imageMainUrl: String, photos: [String], location: CLLocationCoordinate2D, adress: String, type: PlaceClassification ,id: Int) {
        self.title = title
        self.shortDescription = shortDescription
        self.photos = photos
        self.uniqueId = id
        self.adress = adress
        self.location = location
        self.type = type
        self.imageMainUrl = imageMainUrl
    }
    
    init() {}
}





class PlacePoint: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let locationName: String

    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate

        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}
