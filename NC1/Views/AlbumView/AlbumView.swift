//
//  AlbumView.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI
import RealmSwift
import HealthKit

struct AlbumView: View {
    @State private var status: ArchiveStatus = .day
    @State private var isEditing: Bool = false
    @State private var selelctedImage: [ArchiveModel] = []
    
    @ObservedResults(ArchiveModel.self, sortDescriptor: SortDescriptor(keyPath: "savedDate", ascending: false)) var models
    
    @Namespace var namespace
    
    let backgroundColor: Color = Color(red: 237/255, green: 237/255, blue: 237/255)
    let segmentBackColor: Color = .white.opacity(0.65)
    let segmentFrontColor: Color = Color(red: 154/255, green: 154/255, blue: 154/255).opacity(0.65)
    
    var body: some View {
        ScrollView {
            if models.isEmpty {
                Text("보관함이 비어있습니다!")
            } else {
                VStack {
                    switch self.status {
                    case .year:
                        AlbumYearView(status: $status, models: self.models)
                    case .month:
                        AlbumMonthView(status: $status, models: self.models)
                    case .day:
                        AlbumDayView(status: $status, isEditing: $isEditing,  models: self.models)
                    }
                }
            }
        }
        .navigationTitle("보관함")
        .overlay {
            VStack {
                Spacer()
                ZStack {
                    Capsule()
                        .frame(height: 50)
                        .foregroundStyle(backgroundColor)
                    
                    
                    HStack {
                        
                        
                        Spacer()
                        Text("연")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .onTapGesture {
                                withAnimation {
                                    self.status = .year
                                }
                            }
                        Spacer()
                        Text("월")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .onTapGesture {
                                withAnimation {
                                    self.status = .month
                                }
                            }
                            .padding(.horizontal, 40)
                        Spacer()
                        Text("일")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .onTapGesture {
                                withAnimation {
                                    self.status = .day
                                }
                            }
                        
                        Spacer()
                        
                        
                    }
                    .frame(height: 40)
                    .background {
                        
                        GeometryReader { proxy in
                            let width = proxy.size.width / 6
                            
                            switch self.status {
                            case .year:
                                HStack {
                                    Capsule()
                                        .matchedGeometryEffect(id: "cap", in: namespace)
                                        .frame(maxHeight: 100)
                                        .foregroundStyle(segmentFrontColor)

                                    
                                    Spacer(minLength: width * 4)
                                }
                                .padding(5)
                            case .month:
                                HStack {
                                    Spacer(minLength: width * 2)
                                    
                                    Capsule()
                                        .matchedGeometryEffect(id: "cap", in: namespace)
                                        .foregroundStyle(segmentFrontColor)
                                    
                                    Spacer(minLength: width * 2)
                                }
                                .padding(5)
                            case .day:
                                HStack {
                                    Spacer(minLength: width * 4)
                                    
                                    Capsule()
                                        .matchedGeometryEffect(id: "cap", in: namespace)
                                        .foregroundStyle(segmentFrontColor)

                                    
                                }
                                .padding(5)
                            }
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Edit") {
                            self.status = .day
                            self.isEditing = true
                        }
                    }
                }
            }
            .padding(15)
        }
    }
}

enum ArchiveStatus {
    case year
    case month
    case day
}

func getModelImage(_ imageUrl: String) -> some View {
    let url = URL(string: imageUrl)!
    
    let data = try! Data(contentsOf: url)
    
    let image = UIImage(data: data)
    
    return Image(uiImage: image!).resizable()
}
