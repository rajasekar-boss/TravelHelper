//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?
    var searchTrainService: SearchTrainServiceProtocol?

    func fetchallStations() {
        let url = SearchTrainURL.allStations.url()
        searchTrainService?.fetchAllStations(url: url) { [weak self] result in
            switch result {
            case .success(let stations):
                self?.presenter?.stationListFetched(list: stations)
            case .failure(let error):
                switch error {
                case .unReachability:
                    self?.presenter?.showNoInterNetAvailabilityMessage()
                default:
                    self?.presenter?.showGenericErrorMessage()
                }
            }
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        let url = SearchTrainURL.stationData.url(parameters: [sourceCode])

        searchTrainService?.fetchTrainsFromSource(url: url) { [weak self] result in
            switch result {
            case .success(let trainsList):
                if !trainsList.isEmpty {
                    self?.proceesTrainListforDestinationCheck(trainsList: trainsList)
                } else {
                    self?.presenter?.showNoTrainAvailbilityFromSource()
                }
            case .failure(let error):
                switch error {
                case .unReachability:
                    self?.presenter?.showNoInterNetAvailabilityMessage()
                default:
                    self?.presenter?.showGenericErrorMessage()
                }
            }
        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        let group = DispatchGroup()
        let dateString = getTodayDate()
        
        for index in 0...trainsList.count - 1 {
            group.enter()
            let url = SearchTrainURL.trainMovements.url(parameters: [trainsList[index].trainCode ?? "", dateString])
            
            searchTrainService?.getTrainMovements(url: url) { [weak self] result in
                switch result {
                case .success(let trainMovements):
                    if let _movements = trainMovements, let destinationDetails = self?.getDestinationDetails(for: _movements) {
                            _trainsList[index].destinationDetails = destinationDetails
                    }
                    group.leave()
                case .failure(let error):
                    switch error {
                    case .unReachability:
                        self?.presenter?.showNoInterNetAvailabilityMessage()
                    default:
                        self?.presenter?.showGenericErrorMessage()
                    }
                }
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter?.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }

}

extension SearchTrainInteractor {
    private func getTodayDate() -> String {
        return Date().getTodayDate(dateFormat: "dd/MM/yyyy")
    }
    
    private func getDestinationDetails(for trainMovements: TrainMovementsData) -> TrainMovement? {
        let _movements = trainMovements.trainMovements
        let sourceIndex = _movements.firstIndex(where: {$0.locationCode?.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
        let destinationIndex = _movements.firstIndex(where: {$0.locationCode?.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
        let desiredStationMoment = _movements.filter{$0.locationCode?.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
        let isDestinationAvailable = desiredStationMoment.count == 1

        if isDestinationAvailable  && sourceIndex! < destinationIndex! {
            return desiredStationMoment.first
        }
        return nil
    }

}

// MARK: - Favourite station functionality
extension SearchTrainInteractor {
    func updateFavouriteStation(_ station: StationTrain) {
        StationTrain.updateFavouriteStation(station)
    }
    func fetchFavouriteStation() -> StationTrain? {
        return StationTrain.fetchFavouriteStation()
    }
}
