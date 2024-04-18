//
//  MoreDetailView.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI
import HealthKit

struct WorkoutDetailView: View {
    let workout: HKWorkout
    let grayOne: Color = .init(red: 217/255, green: 217/255, blue: 217/255)
    let grayTwo: Color = .init(red: 137/255, green: 137/255, blue: 137/255)
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 280)
                    .foregroundStyle(grayOne)
                
                VStack(spacing: 10) {
                    HStack {
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .grayTwo()
                            
                            VStack(alignment: .leading) {
                                Text("운동 시간")
                                    .detailFirstText()
                                
                                Text(getTime(workout))
                                    .detailSecondText()
                            }
                            .padding(10)
                        }
                        
                        Spacer()
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .grayTwo()
                            
                            VStack(alignment: .leading) {
                                Text("거리")
                                    .detailFirstText()
                                
                                Text(getDistance(workout))
                                    .detailSecondText()
                            }
                            .padding(10)
                        }
                    }
                    
                    HStack {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .grayTwo()
                            
                            VStack(alignment: .leading) {
                                Text("평균 심박수")
                                    .detailFirstText()
                                
                                Text(getHeart(workout))
                                    .detailSecondText()
                            }
                            .padding(10)
                        }
                            
                        Spacer()
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .grayTwo()
                            
                            VStack(alignment: .leading) {
                                Text("평균 페이스")
                                    .detailFirstText()
                                
                                Text(getPace(workout))
                                    .detailSecondText()
                            }
                            .padding(10)
                        }
                    }
                    
                    HStack {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .grayTwo()
                            
                            VStack(alignment: .leading) {
                                Text("케이던스")
                                    .detailFirstText()
                                
                                Text("180SPM")
                                    .detailSecondText()
                            }
                            .padding(10)
                        }
                            
                        Spacer()
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .grayTwo()
                            
                            VStack(alignment: .leading) {
                                Text("평균 파워")
                                    .detailFirstText()
                                
                                Text(getPower(workout))
                                    .detailSecondText()
                            }
                            .padding(10)
                        }
                    }
                }
                .padding(15)
                
            }
            
            WorkoutDetailMapView(workout: self.workout)
        }
        .padding(15)
    }
}



