//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 12.04.2024.
//

import Foundation


class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let index = (0..<movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else {return}
            var imageData = Data()
            
            do{
                imageData = try Data(contentsOf: movie.resizedImageURL)
            }catch {
                print("Failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            let randomRating = Int.random(in: 5...8)
            let text = "Рейтинг этого фильма больше, чем \(randomRating)?"
            let correctAnswer = rating > Float(randomRating)
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self ] in
                guard let self = self else {return}
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}
//    func setup(delegate: QuestionFactoryDelegate) {
//        self.delegate = delegate
//    }
//}
    
//    func requestNextQuestion() {
//        guard let index = (0..<questions.count).randomElement() else {
//            delegate?.didRecieveNextQuestion(question: nil)
//            return
//        }
//        let question = questions[safe: index]
//        delegate?.didRecieveNextQuestion(question: question)
//    }
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 9?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Dark Knight",
//            text: "Рейтинг этого фильма больше чем 8?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Kill Bill",
//            text: "Рейтинг этого фильма больше чем 9?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 7?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Deadpool",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 8?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Old",
//            text: "Рейтинг этого фильма больше чем 5?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 5?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Tesla",
//            text: "Рейтинг этого фильма больше чем 9?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Vivarium",
//            text: "Рейтинг этого фильма больше чем 3?",
//            correctAnswer: true)
//    ]
    
//    func requestNextQuestion() -> QuizQuestion? {
//        guard let index = (0..<questions.count).randomElement() else {
//            return nil
//        }
//        return questions[safe: index]
//    }
//}
