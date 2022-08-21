//
//  Date+Extension.swift
//  MyTravelHelper
//
//  Created by Raj on 20/08/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

extension Date {
    func getTodayDate(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
