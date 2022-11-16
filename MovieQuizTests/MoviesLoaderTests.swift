import Foundation
import XCTest
@testable import MovieQuiz
//
//class moviesLoaderTest: XCTestCase {
//    func testSuccessLoading() throws {
//        //Given
//        let stubNetworkClient = StubNetworkClient(emulateError: false)// говорим, что не хотим эмулировать ошибку
//        let loader = MoviesLoader()
//        //When
//        // так как функция загрузки фильмов — асинхронная, нужно ожидание
//        let expectation = expectation(description: "Loading Expectation")
//        //Then
//        loader.loadMovies { result in
//            switch result {
//            case.success(let movies):
//                // сравниваем данные с тем, что мы предполагали
//                // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
//                XCTAssertEqual(movies.items.count, 2)
//                expectation.fulfill()
//            case.failure(_):
//                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
//                XCTFail("Unexpected failure") // эта функция проваливает тест
//            }
//        }
//        waitForExpectations(timeout: 1)
//    }
//    
//    func testFailureLoading() throws {
//        //Given
//        let stubNetworkClient = StubNetworkClient(emulateError: true)// говорим, что хотим эмулировать ошибку
//        let loader = MoviesLoader(networkClient: stubNetworkClient)
//        //When
//        let expectation = expectation(description: "Loading Expectation")
//        loader.loadMovies { result in
//            //Then
//            switch result {
//            case.failure(let error):
//                XCTAssertNotNil(error)
//                expectation.fulfill()
//            case.success(_):
//                XCTFail("Unexpected failure")
//            }
//        }
//        waitForExpectations(timeout: 1)
//    }
//}
