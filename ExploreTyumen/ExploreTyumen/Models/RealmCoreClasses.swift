//
//  RealmCoreClasses.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 12/25/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//
import RealmSwift
import Foundation

class FirstStartProjects: Object{
    @objc dynamic var isFirstStart:Bool = true
    @objc dynamic var isFirstBest:Bool = true
    @objc dynamic var isFirstQuest:Bool = true
    @objc dynamic var isFirstCollections:Bool = true
}
