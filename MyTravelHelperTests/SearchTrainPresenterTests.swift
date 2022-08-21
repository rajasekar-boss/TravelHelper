//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter?
    var view = SearchTrainMockView()
    var interactor = SearchTrainInteractorMock()
    
    override func setUp() {
        presenter = SearchTrainPresenter()
        presenter?.view = view
        presenter?.interactor = interactor
        interactor.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
    }

    func testfetchallStationsSuccess() {
        interactor.state = .success
        presenter?.fetchallStations()
        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
        XCTAssertEqual(presenter?.stationsList.count, 1)
        let firstStation = presenter?.stationsList.first
        XCTAssertEqual(firstStation?.stationDesc, "Belfast Central")
        XCTAssertEqual(firstStation?.stationLatitude, 54.6123)
        XCTAssertEqual(firstStation?.stationLongitude, -5.91744)
        XCTAssertEqual(firstStation?.stationCode, "BFSTC")
        XCTAssertEqual(firstStation?.stationId, 228)
    }
    
    func testfetchallStationsEmpty() {
        interactor.state = .empty
        presenter?.fetchallStations()
        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
        XCTAssertEqual(presenter?.stationsList.count, 0)
    }

    func testfetchallStationsFailure() {
        interactor.state = .failure
        presenter?.fetchallStations()
        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
        XCTAssertEqual(presenter?.stationsList.count, 0)
    }

    func testTrainListSuccess() {
        interactor.state = .success
        let sourceName = "dubin"
        let destinationName = "foundhound"

        interactor.fetchTrainsFromSource(sourceCode: sourceName, destinationCode: destinationName)
        guard let count = view.trainsList?.count,
              let stationFullName = view.trainsList?.first?.stationFullName,
              let locationFullName = view.trainsList?.first?.destinationDetails?.locationFullName else {
            XCTFail("invalid station")
            return
        }
        XCTAssertEqual(count, 1)
        XCTAssertEqual(stationFullName, sourceName)
        XCTAssertEqual(locationFullName, destinationName)
    }

    func testTrainListEmpty() {
        interactor.state = .empty
        interactor.fetchTrainsFromSource(sourceCode: "dubin", destinationCode: "foundhound")
        XCTAssertNil(view.trainsList)
    }
    
    func testTrainListFailure() {
        interactor.state = .failure
        interactor.fetchTrainsFromSource(sourceCode: "dubin", destinationCode: "foundhound")
        XCTAssertNil(view.trainsList)
    }

    func testErrorMessageAlerts() {
        view.showNoTrainsFoundAlert()
        XCTAssertTrue(view.isNoTrainsFoundAlertCalled)
        
        view.showInvalidSourceOrDestinationAlert()
        XCTAssertTrue(view.isInvalidSourceOrDestinationAlertCalled)
        
        view.showNoInterNetAvailabilityMessage()
        XCTAssertTrue(view.isNoInterNetAvailabilityAlertCalled)

        view.showNoTrainAvailbilityFromSource()
        XCTAssertTrue(view.isNoTrainAvailbilityFromSourceAlertCalled)

        view.showGenericErrorMessage()
        XCTAssertTrue(view.isGenericErrorAlertCalled)
    }
    
    // MARK: - Favourite station functionality
    func testFavouriteStationSuccess() {
        interactor.state = .success
        let stationTrain: StationTrain = getFavouriteStation()
        presenter?.updateFavouriteStation(getFavouriteStation())
        let favouriteStation = presenter?.fetchFavouriteStation()
        XCTAssertEqual(stationTrain.stationFullName, favouriteStation?.stationFullName)
        XCTAssertEqual(stationTrain.stationCode, favouriteStation?.stationCode)
        XCTAssertEqual(stationTrain.expArrival, favouriteStation?.expArrival)
        XCTAssertEqual(stationTrain.destinationDetails?.locationFullName, favouriteStation?.destinationDetails?.locationFullName)
    }

    func testFavouriteStationEmpty() {
        interactor.state = .empty
        presenter?.updateFavouriteStation(getFavouriteStation())
        let favouriteStation = presenter?.fetchFavouriteStation()
        XCTAssertNil(favouriteStation)
    }

    func testFavouriteStationFailure() {
        interactor.state = .failure
        presenter?.updateFavouriteStation(getFavouriteStation())
        let favouriteStation = presenter?.fetchFavouriteStation()
        XCTAssertNil(favouriteStation)
    }

}

// MARK: - Favourite station functionality
extension SearchTrainPresenterTests {
    private func getFavouriteStation() -> StationTrain {
        return StationTrain.init(trainCode: "A123", fullName: "sourceStation", stationCode: "456", trainDate: "5/01/2021", dueIn: 2, lateBy: 3, expArrival: "16:00", expDeparture: "18:00", destinationDetails: TrainMovement.init(trainCode: "A345", locationCode: "798", locationFullName: "destinationStation", expDeparture: "20:00"))
    }
}

class SearchTrainMockView:PresenterToViewProtocol {
    var isSaveFetchedStatinsCalled = false
    var isInvalidSourceOrDestinationAlertCalled = false
    var isNoTrainsFoundAlertCalled = false
    var isNoTrainAvailbilityFromSourceAlertCalled = false
    var isNoInterNetAvailabilityAlertCalled = false
    var isGenericErrorAlertCalled = false
    var trainsList:[StationTrain]?

    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {
        isInvalidSourceOrDestinationAlertCalled = true
    }
    
    func updateLatestTrainList(trainsList: [StationTrain]) {
        self.trainsList = trainsList
    }
    
    func showNoTrainsFoundAlert() {
        isNoTrainsFoundAlertCalled = true
    }
    
    func showNoTrainAvailbilityFromSource() {
        isNoTrainAvailbilityFromSourceAlertCalled = true
    }
    
    func showNoInterNetAvailabilityMessage() {
        isNoInterNetAvailabilityAlertCalled = true
    }
    
    func showGenericErrorMessage() {
        isGenericErrorAlertCalled = true
    }
}

class SearchTrainInteractorMock: PresenterToInteractorProtocol {
    var searchTrainService: SearchTrainServiceProtocol?
    var presenter: InteractorToPresenterProtocol?
    var favoriteStation: StationTrain?

    enum State {
        case success
        case failure
        case empty
    }
    
    var state: State = .success
    
    func fetchallStations() {
        switch state {
        case .success:
            presenter?.stationListFetched(list: getMockStations())
        case .empty, .failure:
            presenter?.stationListFetched(list: [])
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        switch state {
        case .success:
            presenter?.fetchedTrainsList(trainsList: getMockStationTrains(sourceCode, destinationCode))
        case .empty, .failure:
            presenter?.fetchedTrainsList(trainsList: [])
        }
    }
    
    // MARK: - Favourite station functionality
    func updateFavouriteStation(_ station: StationTrain) {
        switch state {
        case .success:
            self.favoriteStation = station
        case .empty, .failure:
            self.favoriteStation = nil
        }
    }
    
    func fetchFavouriteStation() -> StationTrain? {
        switch state {
        case .success:
            return favoriteStation
        case .empty, .failure:
            return nil
        }
    }
}

extension SearchTrainInteractorMock {
    private func getMockStations() -> [Station] {
        let station = Station(desc: "Belfast Central",
                       latitude: 54.6123,
                       longitude: -5.91744,
                       code: "BFSTC",
                       stationId: 228)
        return [station]
    }
    
    private func getMockStationTrains(_ sourceCode: String, _ destinationCode: String) -> [StationTrain] {
        let stationTrain: StationTrain = StationTrain.init(trainCode: "A144",
                                                           fullName: sourceCode,
                                                           stationCode: "BFSTC",
                                                           trainDate: "21 Aug 2022",
                                                           dueIn: 56,
                                                           lateBy: 1,
                                                           expArrival: "14:09",
                                                           expDeparture: "00:00",
                                                           destinationDetails: TrainMovement.init(trainCode: "A345",
                                                                                                  locationCode: "CNLLY",
                                                                                                  locationFullName: destinationCode,
                                                                                                  expDeparture: "20:00"))
        return [stationTrain]
    }
}
