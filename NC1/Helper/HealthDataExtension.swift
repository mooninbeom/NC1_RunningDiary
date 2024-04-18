//
//  HealthDataExtension.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI
import HealthKit

// MARK: - Health data to String
extension View {
    public func getDistance(_ workout: HKWorkout) -> String {
        guard let statistics = workout.statistics(for: HKQuantityType(.distanceWalkingRunning)) else {
            return "error;;"
        }
        let distance = Health.shared.getDistance(myDistance: statistics)
        return "\(distance/1000).\(distance%1000)km"
    }
    
    public func getTime(_ workout: HKWorkout) -> String {
        let time = Int(workout.duration)
        let hour = time/3600
        let minute = (time - hour*3600) / 60
        let second = time - hour*3600 - minute*60
        
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
        let secondString = second < 10 ? "0\(second)" : "\(second)"
        
        return "\(hour):\(minuteString):\(secondString)"
    }
    
    public func getPace(_ workout: HKWorkout) -> String {
        guard let statistics = workout.statistics(for: HKQuantityType(.runningSpeed)) else {
            return "nil"
        }
        let averageSpeed = statistics.averageQuantity()
        let result = Int(averageSpeed!.doubleValue(for: .meter().unitDivided(by: .hour())))
        
        return "\(result/1000).\(result%1000)km/h"
    }
    
    public func getHeart(_ workout: HKWorkout) -> String {
        guard let statistics = workout.statistics(for: HKQuantityType(.heartRate)) else {
            return "nil"
        }
        let averageHeart = statistics.averageQuantity()!
        let result = Int(averageHeart.doubleValue(for: HKUnit(from: "count/min")))
        return "\(result)BPM"
    }
    
    public func getPower(_ workout: HKWorkout) -> String {
        guard let statistics = workout.statistics(for: HKQuantityType(.runningPower)) else {
            return "nil"
        }
        let averagePower = statistics.averageQuantity()!
        let result = Int(averagePower.doubleValue(for: .watt()))
        return "\(result)W"
    }
}
