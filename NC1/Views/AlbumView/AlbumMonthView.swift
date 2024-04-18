//
//  AlbumMonthView.swift
//  NC1
//
//  Created by 문인범 on 4/18/24.
//

import SwiftUI
import RealmSwift


struct AlbumMonthView: View {
    @Binding var status: ArchiveStatus
    let models: Results<ArchiveModel>
    
    var body: some View {
        VStack {
            ForEach(getMonthFilter()) { model in
                let year = String(model.year)
                
                let month = String(model.month)
                
                VStack {
                    HStack {
                        Text("\(year)년 \(month)월")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    getModelImage(model.image)
                        .scaledToFit()
                        .padding(15)
                        .onTapGesture {
                            withAnimation {
                                status = .day
                            }
                        }
                        
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    func getMonthFilter() -> [ArchiveModel] {
        var archiveModel: [ArchiveModel] = []
        
        var year = 0
        var month = 0
        
        for model in models {
            let modelYear = model.year
            let modelMonth = model.month
            
            if year == modelYear {
                if month != modelMonth {
                    archiveModel.append(model)
                    year = modelYear
                    month = modelMonth
                }
            } else {
                archiveModel.append(model)
                year = modelYear
                month = modelMonth
            }
        }
        
        return archiveModel
    }
}

