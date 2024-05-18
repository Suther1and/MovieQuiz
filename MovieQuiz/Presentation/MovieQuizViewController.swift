import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
     
    
     
    //MARK: - Private Properties
    private lazy var correctAnswers = 0
    private lazy var imageView = {
        let image = UIImageView()
        image.backgroundColor = .ypWhite
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.accessibilityIdentifier = "Poster"
        return image
    }()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var yesButton = createButton(title: "Да", action: yesAction, id: "Yes")
    private lazy var noButton = createButton(title: "Нет", action: noAction, id: "No")
    private lazy var questionText = createLabel(text: "Рейтинг этого фильма больше чем 5?", font: "YSDisplay-Bold", size: 23, id: "Rating")
    private lazy var questionTitleLabel = createLabel(text: "Вопрос:", font: "YSDisplay-Medium", size: 20, id: "Question")
    private lazy var indexLabel = createLabel(text: "1/10", font: "YSDisplay-Medium", size: 20, id: "Index")
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var alertPresenter: AlertPresenter?
    private let presenter = MovieQuizPresenter()
    private var currentQuestion: QuizQuestion?

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        activityIndicator.hidesWhenStopped = true
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        showLoadingIndicator()
        questionFactory.loadData()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        presenter.vc = self
        
        [questionTitleLabel,
         noButton,
         yesButton,
         indexLabel,
         imageView,
         questionText,
         activityIndicator].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
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
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height/2 + 80),
            
            questionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 62),
            questionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            questionText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 33),
            questionText.bottomAnchor.constraint(equalTo: yesButton.topAnchor, constant: -33),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        

        ])
    }
    
    //MARK: QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    //MARK: UIActions
    
    private lazy var yesAction = UIAction { _ in
        self.presenter.currentQuestion = self.currentQuestion
        self.presenter.yesButtonClicked()
    }
    
    private lazy var noAction = UIAction { _ in
        self.presenter.currentQuestion = self.currentQuestion
        self.presenter.noButtonClicked()
    }
    
     
    
    //MARK: Private Methods
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
                guard let self else { return }
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                questionFactory?.requestNextQuestion()
            })
        alertPresenter?.presentAlert(alert: alertModel)
    }
    
    private func changeStateButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    private func createLabel(text: String, font: String, size: Int, id: String) -> UILabel {
        {
            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.font = UIFont(name: font, size: CGFloat(size))
            label.textColor = .ypWhite
            label.textAlignment = .center
            label.accessibilityIdentifier = id
            return label
        }()
    }
    
    private func createButton(title: String, action: UIAction, id: String) -> UIButton{
        {
            let button = UIButton(primaryAction: action)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.ypBlack, for: .normal)
            button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
            button.layer.cornerRadius = 15
            button.backgroundColor = .ypWhite
            button.accessibilityIdentifier = id
            return button
        }()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionText.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            let text = """
            Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
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
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.imageView.layer.borderColor = UIColor.clear.cgColor
                self.changeStateButtons(isEnabled: true)
                questionFactory?.requestNextQuestion()
            })
            alertPresenter?.presentAlert(alert: alertModel)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            imageView.layer.borderColor = UIColor.clear.cgColor
            changeStateButtons(isEnabled: true)
        }
    }
    
     func showAnswerResult(isCorrect: Bool) {
        if isCorrect{
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        changeStateButtons(isEnabled: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            
            self.showNextQuestionOrResults()
        }
    }
}

