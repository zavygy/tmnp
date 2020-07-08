//
//  PlaceInPlanQCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 2/24/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit


class PlaceInPlanQCell: UICollectionViewCell {
    @IBOutlet weak var squareElement: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var streetAfterLabel: UILabel!
    
    func setData(_ model: PlaceModel, street: String){
        squareElement.asCircle()
        placeNameLabel.text = model.title
        streetAfterLabel.text = street
    }
    
}

enum PositionInPlan{
    case begin
    case end
    case none
}

