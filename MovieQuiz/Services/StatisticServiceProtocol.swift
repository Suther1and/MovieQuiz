//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 17.04.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double {get}
    var gamesCount: Int {get}
    var bestGame: GameRecord {get}
}
