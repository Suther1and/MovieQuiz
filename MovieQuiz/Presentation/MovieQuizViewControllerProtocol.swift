//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 20.05.2024.
//

import Foundation


protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func changeStateButtons(isEnabled: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showNetworkError(message: String)
    func clearBorders()
}
