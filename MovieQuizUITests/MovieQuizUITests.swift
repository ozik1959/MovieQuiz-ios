import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    func testYesButton() {
        let firstPoster = app.images["Poster"]// находим первоначальный постер
        app.buttons["Yes"].tap()// находим кнопку `Да` и нажимаем её
        let secondPoster = app.images["Poster"]// ещё раз находим постер
        let indexLable = app.staticTexts["Index"]
        
        sleep(3)
        XCTAssertTrue(indexLable.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["No"].tap()
        let secondPoster = app.images["Poster"]
        let indexLable = app.staticTexts["Index"]
        
        sleep(2)
        XCTAssertTrue(indexLable.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        sleep(2)
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        sleep(2)
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}

