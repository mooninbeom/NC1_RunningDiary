//
//  MainView.swift
//  NC1
//
//  Created by 문인범 on 4/15/24.
//

import SwiftUI
import HealthKit
import RealmSwift


struct MainView: View {
    @State private var viewModel = MainViewModel()
    @ObservedResults(ArchiveModel.self) var archives
    
    var body: some View {
        NavigationStack {
            ScrollView {
                NavigationLink {
                    AlbumView()
                } label: {
                    ArchiveView(count: archives.count)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .tint(.black)
                    
                }
                
                
                
                HStack {
                    Text("저장된 운동")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                }
                .padding(EdgeInsets(top: 20, leading: 15, bottom: 5, trailing: 15))

                switch viewModel.modelStatus {
                case .loading:
                    ProgressView()
                case .success:
                    ForEach(viewModel.workouts, id: \.self) { workout in
                        NavigationLink {
                            AddingDiaryView(workout: workout)
                                .padding(15)
                        } label: {
                            SavedWorkoutListView(workout: workout)
                                .padding(.horizontal, 15)
                                .padding(.bottom, 15)
                                .tint(.black)
                        }
                        
                        
                    }
                case .nothing:
                    VStack {
                        Text("저장된 운동이 없습니다😿")
                        Text("운동을 시작해보세요🏃")
                    }
                case .error:
                    VStack {
                        Text("운동을 불러오는 중에 오류가 발생했어요 ㅜㅜ")
                        Text("권한을 허가하지 않은 경우 허가 부탁해요!")
                        Button("권한 부여") {
                            Task.init {
                                await Health.shared.requestAuthorization()
                                await viewModel.fetchHealthData()
                            }
                        }
                    }
                    
                }
                
            }
            .navigationTitle("메인화면")
            .background {
                LinearGradient(colors: [.init(red: 254/255, green: 178/255, blue: 63/255), .init(red: 238/255, green: 238/255, blue: 238/255)], startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
            }
            .task {
                await viewModel.fetchHealthData()
            }
        }
    }
}
