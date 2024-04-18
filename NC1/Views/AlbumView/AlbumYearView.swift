//
//  AlbumYearView.swift
//  NC1
//
//  Created by 문인범 on 4/18/24.
//

import SwiftUI
import RealmSwift



struct AlbumYearView: View {
    @Binding var status: ArchiveStatus
    let models: Results<ArchiveModel>
    
    var body: some View {
        VStack {
            ForEach(getMonthFilter()) { model in
                let year = String(model.year)
                VStack {
                    HStack {
                        Text("\(year)년")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    getModelImage(model.image)
                        .scaledToFit()
                        .padding(15)
                        .onTapGesture {
                            withAnimation(.spring) {
                                status = .month
                            }
                        }
                        
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    func getMonthFilter() -> [ArchiveModel] {
        var archiveModel: [ArchiveModel] = []
        
        var year = 0
        
        for model in models {
            let modelYear = model.year
            
            if year != modelYear {
                archiveModel.append(model)
                year = modelYear
            }
        }
        
        return archiveModel
    }
}
