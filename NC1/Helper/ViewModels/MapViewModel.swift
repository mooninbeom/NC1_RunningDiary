//
//  MapViewModel.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI
import CoreLocation
import HealthKit





@Observable
class MapViewModel {
    var status: MapModelStatus = .loading
    var routes: [CLLocationCoordinate2D] = []
    
    @MainActor
    public func fetchRouteData(workout: HKWorkout) async {
        do {
            let routeSamples = try await Health.shared.getRouteSamples(myWorkout: workout)
            
            if routeSamples.isEmpty {
                status = .error
                return
            }
            
            guard let routeSample = routeSamples.first else {
                status = .error
                return
            }
            
            let routeArray = await Health.shared.getLocationDataForRoute(givenRoute: routeSample)
            
            let result = routeArray.map { (location: CLLocation) -> CLLocationCoordinate2D in
                var result = CLLocationCoordinate2D()
                result.latitude = location.coordinate.latitude
                result.longitude = location.coordinate.longitude
                
                return result
            }
            
            self.routes = result
            self.status = .success
            return
        } catch {
            status = .error
        }
    }
}



enum MapModelStatus {
    case loading
    case success
    case error
}
