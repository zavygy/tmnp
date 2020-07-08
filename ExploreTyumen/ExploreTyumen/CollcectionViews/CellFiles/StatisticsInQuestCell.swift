//
//  StatisticsInQuestCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 3/7/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class StatisticsInQuestCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setData(_ value: String, _ description: String){
        valueLabel.text = value
        descriptionLabel.text = description
    }
    
}
