//
//  Health.swift
//  NC1
//
//  Created by 문인범 on 4/15/24.
//

import HealthKit
import CoreLocation
import UIKit
import HealthKitUI

struct Health {
    static let shared = Health()
    
    let store = HKHealthStore()
    
    let allTypes = Set([
        HKQuantityType.workoutType(),
        HKSeriesType.workoutRoute(),
        HKObjectType.activitySummaryType()
    ])
    
}


// MARK: - 데이터 접근 메소드
extension Health {
    // 권한 허가
    func requestAuthorization() async {
        do {
            if HKHealthStore.isHealthDataAvailable() {
                try await store.requestAuthorization(toShare: Set(), read: allTypes)
            }
        } catch {
            print("건강 정보 허용 실패 \(error.localizedDescription)")
        }
    }

    // 러닝 기록 불러오기
    func readWorkouts() async throws -> [HKWorkout]? {
        let running = HKQuery.predicateForWorkouts(with: .running)
        
        do {
            let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
                
                store.execute(HKSampleQuery(
                    sampleType: .workoutType(),
                    predicate: running,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)],
                    resultsHandler:
                        { query, samples, error in
                            if let error = error {
                                continuation.resume(throwing: error)
                                return
                            }
                            
                            guard let samples = samples else {
                                fatalError("sample error!")
                            }
                            
                            
                            continuation.resume(returning: samples)
                        }))
                
            }
            
            guard let workouts = samples as? [HKWorkout] else {
                return nil
            }
            return workouts
        } catch {
            throw HealthError.readWorkoutsError
        }
    }

    
    
    
    // HKWorkout에서 HKWorkoutRoute 뽑아내기
    func getRouteSamples(myWorkout: HKWorkout) async throws -> [HKWorkoutRoute] {
        let runningObjectQuery = HKQuery.predicateForObjects(from: myWorkout)
        
        
        do {
            let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKWorkoutRoute], Error>) in
                let query = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samplesOrNil, deletedObjectOrNil, anchorOrNil, errorOrNil) in
                    
                    if let error = errorOrNil {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let samples = samplesOrNil as? [HKWorkoutRoute] else {
                        fatalError("get route samples error")
                    }
                    
                    continuation.resume(returning: samples)
                }
                
                store.execute(query)
            }
            return samples
            
        } catch {
//            fatalError("겟 루트 샘플 실패다 이말이야")
            throw HealthError.getRouteSamplesError
        }
    }
        
        
    // HKWorkoutRoute에서 CLLocation 배열 만들어내기
    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        do {
            let locations = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
                
                var allLocations: [CLLocation] = []
                
                
                let query = HKWorkoutRouteQuery(route: givenRoute) { query, locationOrNil, done, errorOrNil in
                    
                    if let error = errorOrNil {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    
                    guard let currentLocationBatch = locationOrNil else {
                        fatalError("currentLocationBatch")
                    }
                    
                    allLocations.append(contentsOf: currentLocationBatch)
                    
                    if done {
                        continuation.resume(returning: allLocations)
                    }
                }
                
                store.execute(query)
            }
            
            return locations
            
        } catch {
            fatalError("Route data error: \(error.localizedDescription)")
        }
    }
    
    
    // Activity summary 데이터를 받아와 HKActivityRingView로 반환
    public func getActivitySummary(date: DateComponents) async -> HKActivityRingView {
        let predicate = HKQuery.predicateForActivitySummary(with: date)
        
        do {
            let summary = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKActivitySummary]?, Error>) in
                let query = HKActivitySummaryQuery(predicate: predicate) { (query, summariesOrNil, errorOrNil) in
                    if let error = errorOrNil {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let summaries = summariesOrNil else {
                        fatalError()
                    }
                    
                    continuation.resume(returning: summaries)
                }
                store.execute(query)
            }
            
            let view = await HKActivityRingView()
            await view.setActivitySummary(summary!.first!, animated: true)
            
            return view
        } catch {
            fatalError()
        }
    }
}


// MARK: - 계산 메소드
extension Health {
    // 달리기 거리 계산
    func getDistance(myDistance: HKStatistics) -> Int {
        guard let sum = myDistance.sumQuantity() else {
            return -1
        }
        
        let doubleDistance = sum.doubleValue(for: .meter())
        let result = Int(doubleDistance)
        return result
    }
}

enum HealthError: Error {
    case readWorkoutsError
    case getRouteSamplesError
    case getLocationDataError
}

extension Date {
    public func dateToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        let result = formatter.string(from: self)
        return result
    }
}
