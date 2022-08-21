//
//  ApiUrls.swift
//  MyTravelHelper
//
//  Created by Raj on 20/08/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

protocol URLProtocol {
    var baseUrl: String { get }
    func url(parameters: [CVarArg]?) -> URL
}

extension URLProtocol where Self: RawRepresentable, Self.RawValue == String {
    func url(parameters: [CVarArg]? = nil) -> URL {
        var formattedUrlString = self.rawValue
        if let urlParameters: [CVarArg] = parameters {
            formattedUrlString = String(format: self.rawValue, arguments: urlParameters)
        }
        guard let urlValue = URL(string: baseUrl + formattedUrlString) else {
            fatalError("Request URL was nil for \(baseUrl) \(self.rawValue)")
        }
        return urlValue
    }
}

// MARK: - Keep a distinct enum for each journey
enum SearchTrainURL: String, URLProtocol {
    // End points
    case allStations = "/getAllStationsXML"
    case stationData = "/getStationDataByCodeXML?StationCode=%@"
    case trainMovements = "/getTrainMovementsXML?TrainId=%@&TrainDate=%@"

    // Base url
    var baseUrl: String {
        return "http://api.irishrail.ie/realtime/realtime.asmx"
    }
}
