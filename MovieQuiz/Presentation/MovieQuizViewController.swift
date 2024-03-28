import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    //MARK: - массив вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    //MARK: - Структуры
    
    struct QuizQuestion {
        // строка с названием фильма,
        // совпадает с названием картинки афиши фильма в Assets
        let image: String
        // строка с вопросом о рейтинге фильма
        let text: String
        // булевое значение (true, false), правильный ответ на вопрос
        let correctAnswer: Bool
    }
    
    // вью модель для состояния "Вопрос показан"
    struct QuizStepViewModel {
        // картинка с афишей фильма с типом UIImage
        let image: UIImage
        // вопрос о рейтинге квиза
        let question: String
        // строка с порядковым номером этого вопроса (ex. "1/10")
        let questionNumber: String
    }
    
    lazy var currentQuestion = questions[currentQuestionIndex]
    lazy var currentQuestionIndex = 0
    lazy var correctAnswers = 0
    
   

    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionText.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNextQuestionOrResults()
            }
    }
    
    
    
//    lazy var alert = UIAlertController(
//        title: "Этот раунд окончен!",
//        message: "Ваш результат ???",
//        preferredStyle: .alert)
//
//    lazy var action = UIAlertAction(title: result.buttonText, style: .default) { _ in
//        self.currentQuestionIndex = 0
//        // сбрасываем переменную с количеством правильных ответов
//        self.correctAnswers = 0
//        
//        // заново показываем первый вопрос
//        let firstQuestion = self.questions[self.currentQuestionIndex]
//        let viewModel = self.convert(model: firstQuestion)
//        self.present(alert, animated: true, completion: nil)
//
//        self.show(quiz: viewModel)
//    }

 
   

     
   
    
    
    
    
    
    
    
    
    //MARK: - Объекты интерфейса
    lazy var imageView = {
        let image = UIImageView()
        image.backgroundColor = .ypWhite
        image.layer.cornerRadius = 20
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    
    func createLabel(text: String, font: String, size: Int) -> UILabel {
        {
            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: font, size: CGFloat(size))
            label.textColor = .ypWhite
            label.textAlignment = .center
            
            return label
        }()
    }
    
    func createButton(title: String, action: UIAction) -> UIButton{
        {
            let button = UIButton(primaryAction: action)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.setTitleColor(.ypBlack, for: .normal)
            button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
            button.layer.cornerRadius = 15
            button.backgroundColor = .ypWhite
            return button
        }()
    }
    
    lazy var noAction = UIAction { _ in
        let currentQuestion = self.questions[self.currentQuestionIndex]
        let givenAnswer = false
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    lazy var yesAction = UIAction { _ in
        let currentQuestion = self.questions[self.currentQuestionIndex]
        let givenAnswer = true
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    lazy var yesButton = createButton(title: "Да", action: yesAction)
    lazy var noButton = createButton(title: "Нет", action: noAction)
    lazy var questionText = createLabel(text: "Рейтинг этого фильма больше чем 5?", font: "YSDisplay-Bold", size: 23)
    lazy var questionTitleLabel = createLabel(text: "Вопрос:", font: "YSDisplay-Medium", size: 20)
    lazy var indexLabel = createLabel(text: "1/10", font: "YSDisplay-Medium", size: 20)
    
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        show(quiz: convert(model: currentQuestion))
        
        
        
//        alert.addAction(action)
        view.addSubview(questionTitleLabel)
        view.addSubview(noButton)
        view.addSubview(yesButton)
        view.addSubview(indexLabel)
        view.addSubview(imageView)
        view.addSubview(questionText)
        
        NSLayoutConstraint.activate([
            noButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noButton.widthAnchor.constraint(equalToConstant: (view.frame.width/2) - 30),
            noButton.heightAnchor.constraint(equalToConstant: 60),
            
            yesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            yesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            yesButton.widthAnchor.constraint(equalToConstant: (view.frame.width/2) - 30),
            yesButton.heightAnchor.constraint(equalToConstant: 60),
            
            questionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            questionTitleLabel.widthAnchor.constraint(equalToConstant: 74),
            questionTitleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            indexLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            indexLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            indexLabel.widthAnchor.constraint(equalToConstant: 50),
            indexLabel.heightAnchor.constraint(equalToConstant: 24),
            
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: questionTitleLabel.bottomAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -212),
            
            questionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 62),
            questionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            questionText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
        ])
    }
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
