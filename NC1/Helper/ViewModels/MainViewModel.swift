//
//  MainViewModel.swift
//  NC1
//
//  Created by 문인범 on 4/15/24.
//

import SwiftUI
import HealthKit
import RealmSwift

@Observable
class MainViewModel {
    var modelStatus: MainModelStatus = .loading
    var archiveCount: Int = 0
    var workouts: [HKWorkout] = []
        
    @MainActor
    public func fetchHealthData() async {
        do {
            let workouts = try await Health.shared.readWorkouts()
            
            guard let result = workouts else {
                self.modelStatus = .error
                return
            }
            
            if result.isEmpty {
                self.modelStatus = .nothing
                return
            }
            
            let data = makeData()
            
            self.workouts = result.filter { workout in
                let uuid = workout.uuid
                for model in data {
                    if uuid == model.workout {
                        return false
                    }
                }
                return true
            }
            modelStatus = .success
            
        } catch {
            self.modelStatus = .error
        }
    }
    
    public func makeData() -> Results<ArchiveModel> {
        let realm = try! Realm()
        let result = realm.objects(ArchiveModel.self)
        return result
    }
}


enum MainModelStatus {
    case loading
    case success
    case nothing
    case error
}


