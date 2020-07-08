//
//  QuestionToPLace.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 22/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation

class QuestionForPlace{
    var questText: String?
    var answer1: String?
    var answer2: String?
    var answer3: String?
    var rightAnswer:String?
    init(text: String, answ1: String, answ2: String, answ3: String, rightAnsw: String) {
        self.questText = text
        self.answer1 = answ1
        self.answer2 = answ2
        self.answer3 = answ3
        self.rightAnswer = rightAnsw
    }
    init() {}
}
