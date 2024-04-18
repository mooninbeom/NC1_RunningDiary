//
//  WorkoutDetailMapView.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI
import MapKit
import HealthKit

struct WorkoutDetailMapView: View {
    @State private var viewModel = MapViewModel()
    let workout: HKWorkout
    
    private let gradient = LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing)
    private let stroke = StrokeStyle(lineWidth: 3, lineCap: .round)
    
    var body: some View {
        VStack {
            switch viewModel.status {
            case .loading:
                ProgressView()
                    .frame(height: 350)
            case .success:
                Map {
                    MapPolyline(coordinates: viewModel.routes)
                        .stroke(.orange, style: stroke)
                        
                }
                .frame(height: 350)
            case .error:
                Text("지도를 불러오는 중 오류 발생!!")
            }
        }
        .task {
            await viewModel.fetchRouteData(workout: workout)
        }
    }
}
