//
//  SearchTrainService.swift
//  MyTravelHelper
//
//  Created by Raj on 20/08/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

enum SearchTrainError: Error {
    case unReachability
    case invalidRequest
    case genericError
}

protocol SearchTrainServiceProtocol: AnyObject {
    func fetchAllStations(url: URL, completion: @escaping (Result<[Station], SearchTrainError>) -> Void)
    func fetchTrainsFromSource(url: URL, completion: @escaping (Result<[StationTrain], SearchTrainError>) -> Void)
    func getTrainMovements(url: URL, completion: @escaping (Result<TrainMovementsData?, SearchTrainError>) -> Void)
}

class SearchTrainService: SearchTrainServiceProtocol {
    
    let networkProvider = ApiManager()
    
    func fetchAllStations(url: URL, completion: @escaping (Result<[Station], SearchTrainError>) -> Void) {
        networkProvider.request(fromURL: url, httpMethod: .get) { (result: Result<Stations, Error>) in
            switch result {
            case .success(let stations):
                completion(.success(stations.stationsList))
            case .failure(let error):
                let error = error as NSError
                switch error.code {
                case 0:
                    completion(.failure(.unReachability))
                case 400...404:
                    completion(.failure(.invalidRequest))
                default:
                    completion(.failure(.genericError))
                }
            }
         }
    }
    
    func fetchTrainsFromSource(url: URL, completion: @escaping (Result<[StationTrain], SearchTrainError>) -> Void) {
        networkProvider.request(fromURL: url, httpMethod: .get) { (result: Result<StationData, Error>) in
            
            switch result {
            case .success(let stationData):
                completion(.success(stationData.trainsList ?? []))
            case .failure(let error):
                let error = error as NSError
                switch error.code {
                case 0:
                    completion(.failure(.unReachability))
                case 400...404:
                    completion(.failure(.invalidRequest))
                default:
                    completion(.failure(.genericError))
                }
            }
         }
    }
    
    func getTrainMovements(url: URL, completion: @escaping (Result<TrainMovementsData?, SearchTrainError>) -> Void) {
        networkProvider.request(fromURL: url, httpMethod: .get) { (result: Result<TrainMovementsData, Error>) in
            
            switch result {
            case .success(let trainData):
                completion(.success(trainData))
            case .failure(let error):
                let error = error as NSError
                switch error.code {
                case 0:
                    completion(.failure(.unReachability))
                case 400...404:
                    completion(.failure(.invalidRequest))
                default:
                    completion(.failure(.genericError))
                }
            }
         }
    }
}
