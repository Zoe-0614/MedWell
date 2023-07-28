//
//  StatisticsViewModel.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Soo yew Lim on 04/06/2023.
//

import SwiftUI

// MARK: Statistics View Model and Mock Data
/// The view model for managing statistics.
struct StatisticsViewModel: Identifiable {
    
    /// The unique identifier of the view model.
    var id = UUID().uuidString
    
    /// The hour associated with the statistics.
    var hour: Date
    
    /// The statistical values.
    var values: Double
    
    /// Flag to indicate whether to animate the statistics.
    var animate: Bool = false

}

extension Date{
    //MARK: To update Date For Particular Hour
    /// Updates the hour component of the date.
    /// - Parameter value: The hour value.
    /// - Returns: The updated date with the specified hour.
    func updateHour(value: Int) -> Date{
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

/// Mock analytics data for testing purposes.
var sample_analytics: [StatisticsViewModel] = [
    StatisticsViewModel(hour: Date().updateHour(value: 8), values: 70),
    StatisticsViewModel(hour: Date().updateHour(value: 9), values: 120),
    StatisticsViewModel(hour: Date().updateHour(value: 10), values: 100),
    StatisticsViewModel(hour: Date().updateHour(value: 11), values: 80),
    StatisticsViewModel(hour: Date().updateHour(value: 12), values: 85),
    StatisticsViewModel(hour: Date().updateHour(value: 13), values: 83),
    StatisticsViewModel(hour: Date().updateHour(value: 14), values: 68),
    StatisticsViewModel(hour: Date().updateHour(value: 15), values: 65),
    StatisticsViewModel(hour: Date().updateHour(value: 16), values: 75),
    StatisticsViewModel(hour: Date().updateHour(value: 17), values: 89),
    StatisticsViewModel(hour: Date().updateHour(value: 18), values: 90),
    StatisticsViewModel(hour: Date().updateHour(value:19), values: 81),
    StatisticsViewModel(hour: Date().updateHour(value: 20), values: 71)
]

