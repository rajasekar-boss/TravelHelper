//
//  StationInfo.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct StationData: Codable {
    var trainsList: [StationTrain]?

    enum CodingKeys: String, CodingKey {
        case trainsList = "objStationData"
    }
    
    init(trainsList: [StationTrain]?) {
        self.trainsList = trainsList
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let trainsList = try? values.decodeIfPresent([StationTrain].self, forKey: .trainsList)
        self.init(trainsList: trainsList)
    }
}

struct StationTrain: Codable {
    var trainCode: String?
    var stationFullName: String?
    var stationCode: String?
    var trainDate: String?
    var dueIn: Int?
    var lateBy:Int?
    var expArrival:String?
    var expDeparture:String?
    var destinationDetails:TrainMovement?

    enum CodingKeys: String, CodingKey {
        case trainCode = "Traincode"
        case stationFullName = "Stationfullname"
        case stationCode = "Stationcode"
        case trainDate = "Traindate"
        case dueIn = "Duein"
        case lateBy = "Late"
        case expArrival = "Exparrival"
        case expDeparture = "Expdepart"
        case destinationDetails = "destinationDetails"
    }

    init(trainCode: String?, fullName: String?, stationCode: String?, trainDate: String?, dueIn: Int?,lateBy:Int?,expArrival:String?,expDeparture:String?,
         destinationDetails: TrainMovement?) {
        self.trainCode = trainCode
        self.stationFullName = fullName
        self.stationCode = stationCode
        self.trainDate = trainDate
        self.dueIn = dueIn
        self.lateBy = lateBy
        self.expArrival = expArrival
        self.expDeparture = expDeparture
        self.destinationDetails = destinationDetails
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let trainCode = try values.decodeIfPresent(String.self, forKey: .trainCode)
        let fullName = try values.decodeIfPresent(String.self, forKey: .stationFullName)
        let code = try values.decodeIfPresent(String.self, forKey: .stationCode)
        let trainDate = try values.decodeIfPresent(String.self, forKey: .trainDate)
        let dueIn = try values.decodeIfPresent(Int.self, forKey: .dueIn)
        let late = try values.decodeIfPresent(Int.self, forKey: .lateBy)
        let arrival = try values.decodeIfPresent(String.self, forKey: .expArrival)
        let departure = try values.decodeIfPresent(String.self, forKey: .expDeparture)
        let destinationDetails = try? values.decodeIfPresent(TrainMovement.self, forKey: .destinationDetails)

        self.init(trainCode: trainCode, fullName: fullName, stationCode: code, trainDate: trainDate, dueIn: dueIn, lateBy: late, expArrival: arrival, expDeparture: departure,  destinationDetails: destinationDetails)
    }
}

// MARK: - Favourite station functionality
extension StationTrain {
    static func updateFavouriteStation(_ station: StationTrain) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(station), forKey: "FavouriteStation")
    }
    static func fetchFavouriteStation() -> StationTrain? {
        if let data = UserDefaults.standard.value(forKey: "FavouriteStation") as? Data {
            let station = try? PropertyListDecoder().decode(StationTrain.self, from: data)
            return station
        }
        return nil
    }
}
