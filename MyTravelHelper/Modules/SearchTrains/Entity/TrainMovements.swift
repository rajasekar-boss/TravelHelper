//
//  TrainMovements.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct TrainMovementsData: Codable {
    var trainMovements: [TrainMovement]

    enum CodingKeys: String, CodingKey {
        case trainMovements = "objTrainMovements"
    }
}

struct TrainMovement: Codable {
    var trainCode: String?
    var locationCode: String?
    var locationFullName: String?
    var expDeparture:String?

    enum CodingKeys: String, CodingKey {
        case trainCode = "TrainCode"
        case locationCode = "LocationCode"
        case locationFullName = "LocationFullName"
        case expDeparture = "ExpectedDeparture"
    }

    init(trainCode: String?, locationCode: String?, locationFullName: String?, expDeparture:String?) {
        self.trainCode = trainCode
        self.locationCode = locationCode
        self.locationFullName = locationFullName
        self.expDeparture = expDeparture
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let trainCode = try values.decodeIfPresent(String.self, forKey: .trainCode)
        let locationCode = try values.decodeIfPresent(String.self, forKey: .locationCode)
        let locationFullName = try values.decodeIfPresent(String.self, forKey: .locationFullName)
        let departure = try values.decodeIfPresent(String.self, forKey: .expDeparture)
        self.init(trainCode: trainCode, locationCode: locationCode, locationFullName: locationFullName,expDeparture: departure)
    }
}
