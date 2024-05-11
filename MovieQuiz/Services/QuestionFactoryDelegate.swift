//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 14.04.2024.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
