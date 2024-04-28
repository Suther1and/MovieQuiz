//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 17.04.2024.
//

import Foundation

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}

