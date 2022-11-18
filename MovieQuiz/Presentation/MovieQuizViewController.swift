import UIKit
final class MovieQuizViewController: UIViewController, AlertPresentProtocol, MovieQuizViewControllerProtocol{
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var alertPresenterDelegate: AlertPresenterDelegate?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenterDelegate = AlertPresenter(startOverDelegate: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    func startOver() {
        presenter.restartGame()
    }
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alertModel = AlertModel(title: result.title,
                               message: message,
                               buttonText: result.buttonText)
        
        guard let alert = alertPresenterDelegate?.showAlert(alertModel: alertModel) else { return }
        present(alert, animated: true)
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    func makeButtonsActive() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз!"){ [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        guard let alert = alertPresenterDelegate?.showAlert(alertModel: alertModel) else { return }
        present(alert,animated: true)

        }

        

    // MARK: Buttons YES and NO
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
}

