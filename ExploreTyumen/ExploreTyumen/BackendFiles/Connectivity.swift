//
//  Connectivity.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 12/6/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
