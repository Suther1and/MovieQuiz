//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 20.05.2024.
//

import Foundation


protocol MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func changeStateButtons(isEnabled: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    
}
