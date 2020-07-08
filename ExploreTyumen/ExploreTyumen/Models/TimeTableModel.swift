//
//  TimeTableModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 21/01/2019.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class TimeTableModel {
    var mondayTime: String?
    var tuesdayTime: String?
    var wednesdayTime: String?
    var thursdayTime: String?
    var fridayTime: String?
    var saturdayTime: String?
    var sundayTime: String?
    
    init(_ monday: String, _ tuesday: String, _ wednesday: String, _ thursday: String, _ friday: String, _ saturday: String, _ sunday: String) {
        self.mondayTime = monday
        self.tuesdayTime = tuesday
        self.wednesdayTime = wednesday
        self.thursdayTime = thursday
        self.fridayTime = friday
        self.saturdayTime = saturday
        self.sundayTime = sunday
    }
    
    init() {}
}
