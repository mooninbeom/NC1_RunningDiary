//
//  SavedWorkoutListView.swift
//  NC1
//
//  Created by 문인범 on 4/18/24.
//

import SwiftUI
import HealthKit


struct SavedWorkoutListView: View {
    @State var ringView = ActivityRingView()
    let workout: HKWorkout
    let textColor: Color = Color(red: 1, green: 80/255, blue: 80/255)
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "flame.fill")

                Text(getDate())
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
            }
            .foregroundStyle(textColor)
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 100)
                    .foregroundStyle(.white)
                
                HStack(spacing: 15) {
                    switch ringView.ringViewModel.modelStatus {
                    case .loading:
                        ProgressView()
                    case .success:
                        ringView
                            .frame(width: 60, height: 60)
                    case .failure:
                        EmptyView()
                    }
                    
                    Image(systemName: "figure.run")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    
                    VStack(alignment: .leading) {
                        
                        Label(
                            title: { Text(getDistance()) },
                            icon: { Image(systemName: "ruler") }
                        )
                        .font(.system(size: 18, weight: .semibold))
                        
                        Label(
                            title: { Text(getTime()) },
                            icon: { Image(systemName: "clock") }
                        )
                        .font(.system(size: 18, weight: .semibold))
                        
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 40)
                        .foregroundStyle(Color(red: 254/255, green: 98/255, blue: 98/255))
                }
                .padding(.horizontal, 25)
            }
            .task {
                await ringView.ringViewModel.fetchActivityRing(workout: self.workout)
            }
        }
    }
    
    private func getDate() -> String {
        let date = self.workout.endDate
        let format = "yyyy년 MM월 dd일"
        let result = date.dateToString(format: format)
        return result
    }
    
    private func getDistance() -> String {
        guard let statistics = self.workout.statistics(for: HKQuantityType(.distanceWalkingRunning)) else {
            return "error;;"
        }
        
        let distance = Health.shared.getDistance(myDistance: statistics)
        return "\(distance/1000).\(distance%1000)km"
    }
    
    private func getTime() -> String {
        let time = Int(self.workout.duration)
        let hour = time/3600
        let minute = (time - hour*3600) / 60
        let second = time - hour*3600 - minute*60
        
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
        let secondString = second < 10 ? "0\(second)" : "\(second)"
        
        return "\(hour):\(minuteString):\(secondString)"
    }
}
