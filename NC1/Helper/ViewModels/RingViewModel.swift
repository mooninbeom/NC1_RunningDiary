//
//  RingViewModel.swift
//  NC1
//
//  Created by 문인범 on 4/20/24.
//

import HealthKitUI



@Observable
class RingViewModel {
    var modelStatus: RingViewStatus = .loading
    var ringView: HKActivityRingView?
    
    @MainActor
    public func fetchActivityRing(workout: HKWorkout) async {
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: workout.startDate)
        dateComponents.calendar = calendar

        ringView = await Health.shared.getActivitySummary(date: dateComponents)
        
        modelStatus = .success
    }
}


enum RingViewStatus {
    case loading
    case success
    case failure
}
