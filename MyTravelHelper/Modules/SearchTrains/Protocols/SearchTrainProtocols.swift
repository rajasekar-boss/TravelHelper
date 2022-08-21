//
//  SearchTrainProtocols.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

protocol ViewToPresenterProtocol: AnyObject {
    var view: PresenterToViewProtocol? { get set }
    var interactor: PresenterToInteractorProtocol? { get set }
    var router: PresenterToRouterProtocol? { get set }
    func fetchallStations()
    func searchTapped(source: String, destination: String)
    func updateFavouriteStation(_ station: StationTrain)
    // MARK: - Favourite station functionality
    func fetchFavouriteStation()->StationTrain?
}

protocol PresenterToViewProtocol: AnyObject {
    func saveFetchedStations(stations: [Station]?)
    func showInvalidSourceOrDestinationAlert()
    func updateLatestTrainList(trainsList: [StationTrain])
    func showNoTrainsFoundAlert()
    func showNoTrainAvailbilityFromSource()
    func showNoInterNetAvailabilityMessage()
    func showGenericErrorMessage()
}

protocol PresenterToRouterProtocol: AnyObject {
    static func createModule() -> SearchTrainViewController?
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter:InteractorToPresenterProtocol? { get set }
    var searchTrainService: SearchTrainServiceProtocol? { get set }
    func fetchallStations()
    func fetchTrainsFromSource(sourceCode: String, destinationCode: String)
    func updateFavouriteStation(_ station: StationTrain)
    // MARK: - Favourite station functionality
    func fetchFavouriteStation()->StationTrain?
}

protocol InteractorToPresenterProtocol: AnyObject {
    func stationListFetched(list: [Station])
    func fetchedTrainsList(trainsList: [StationTrain]?)
    func showNoTrainAvailbilityFromSource()
    func showNoInterNetAvailabilityMessage()
    func showGenericErrorMessage()
    // MARK: - Favourite station functionality
    func fetchFavouriteStation() -> StationTrain?
}
