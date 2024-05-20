//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 18.05.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Private Properties
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    weak var vc: MovieQuizViewController?
    private var statisticService: StatisticServiceProtocol?
 
    //MARK: Initializer
    init() {
        self.statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        vc?.showLoadingIndicator()
    }
    
    // MARK: Public Methods
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(correct: true)
    }
    
    func noButtonClicked() {
        didAnswer(correct: false)
    }
    
    func didAnswer(isCorrect: Bool) {
        if isCorrect{
            correctAnswers += 1
        }
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.vc?.show(quiz: viewModel)
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrect: isCorrect)
        vc?.changeStateButtons(isEnabled: false)
        vc?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.proceedToNextQuestionOrResult()
        }
    }
    func showNetworkError(message: String) {
        vc?.hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
                guard let self else { return }
                restartGame()
            })
        let alertPresenter = AlertPresenter()
        alertPresenter.presentAlert(vc: vc!, alert: alertModel)
    }
    
    // MARK: Private methods
    private func didAnswer(correct: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = correct
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: Alert
    func proceedToNextQuestionOrResult() {
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            
            let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
            Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%
            """
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    guard let self else { return }
                    self.restartGame()
                    vc?.imageView.layer.borderColor = UIColor.clear.cgColor
                    vc?.changeStateButtons(isEnabled: true)
                })
            let alertPresenter = AlertPresenter()
            alertPresenter.presentAlert(vc: vc!, alert: alertModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            vc?.imageView.layer.borderColor = UIColor.clear.cgColor
            vc?.changeStateButtons(isEnabled: true)
        }
    }
    
    //MARK: QuestionFactoryDelegate
    func didLoadDataFromServer() {
        vc?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        let message = error.localizedDescription
        showNetworkError(message: message)
    }
}
