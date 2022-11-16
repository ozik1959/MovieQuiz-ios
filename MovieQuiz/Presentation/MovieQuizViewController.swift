import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresentProtocol {
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenterDelegate: AlertPresenterDelegate?
    private var statisticServiceImplementation: StatisticServiceImplementation?
    private var moviesLoader: MoviesLoader?
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory?.requestNextQuestion()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenterDelegate = AlertPresenter(startOverDelegate: self)
        statisticServiceImplementation = StatisticServiceImplementation()
        imageView.layer.cornerRadius = 20
        questionFactory?.loadData()
        showLoadingIndicator()
        presenter.viewController = self
    }
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
             return
        }
        print(question.text)
        presenter.didRecieveNextQuestion(question: question)
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
        
    }
    
    func startOver() {
        presenter.resetQuestionIndex()
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
        self.textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        guard let statisticServiceImplementation = statisticServiceImplementation else { return }
        self.statisticServiceImplementation?.store(correct: correctAnswers, total: presenter.questionsAmount)
        self.statisticServiceImplementation?.gamesQuizCount += 1
        self.statisticServiceImplementation?.correctAnswersAllTheTime += correctAnswers
        self.statisticServiceImplementation?.questionsAllTheTime += presenter.questionsAmount
        self.statisticServiceImplementation?.totalAccuracy = Double(statisticServiceImplementation.correctAnswersAllTheTime) / Double(statisticServiceImplementation.questionsAllTheTime) * 100
        // MARK: - AlertModel
        let alertModel = AlertModel(title: result.title,
                                    masseg: """
                                    Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                                    Количеств сыгранных квизов: \(statisticServiceImplementation.gamesQuizCount)
                                    Рекорд: \(statisticServiceImplementation.bestGame.correct)/\(presenter.questionsAmount) (\(statisticServiceImplementation.bestGame.date.dateTimeString))
                                    Средняя точность: \(String(format:"%.2f",statisticServiceImplementation.totalAccuracy))%
                                    """,
                                    buttonText: result.buttonText)
        guard let alertPresenterDelegate = alertPresenterDelegate else {return}
        present(alertPresenterDelegate.showAlert(alertModel: alertModel), animated: true)
        
    }
    
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor
        imageView.layer.cornerRadius = 20
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in// запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        if presenter.isLastQuestion() {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        // MARK: Alert Error
        let alertError = AlertModel(title: "Ошибка",
                                    masseg: message,
                                    buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            self.startOver()
        }
        guard let alertError = alertPresenterDelegate?.showAlert(alertModel: alertError) else { return }
        present(alertError, animated: true)
    }
    
    // MARK: Buttons YES and NO
    @IBAction private func yesButtonClicked(_ sender: Any) {

        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {

        presenter.noButtonClicked()
    }
    
}

