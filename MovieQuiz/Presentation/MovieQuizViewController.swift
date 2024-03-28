import UIKit

final class MovieQuizViewController: UIViewController {
    

    
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
    
    func createButton(title: String) -> UIButton{
        {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.setTitleColor(.ypBlack, for: .normal)
            button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
            button.layer.cornerRadius = 15
            button.backgroundColor = .ypWhite
            return button
        }()
    }
    
    lazy var yesButton = createButton(title: "Да")
    lazy var noButton = createButton(title: "Нет")
    lazy var questionText = createLabel(text: "Рейтинг этого фильма больше чем 5?", font: "YSDisplay-Bold", size: 23)
    lazy var questionTitleLabel = createLabel(text: "Вопрос:", font: "YSDisplay-Medium", size: 20)
    lazy var indexLabel = createLabel(text: "1/10", font: "YSDisplay-Medium", size: 20)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack

      
        
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
            indexLabel.widthAnchor.constraint(equalToConstant: 37),
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
