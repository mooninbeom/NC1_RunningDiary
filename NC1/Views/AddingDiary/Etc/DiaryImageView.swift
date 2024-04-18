//
//  DiaryImageView.swift
//  NC1
//
//  Created by 문인범 on 4/18/24.
//

import SwiftUI
import HealthKit



struct DiaryImageView: View {
    @Binding var text: String
    @Binding var imageData: Data?
    
    @Binding var color: Color
    let workout: HKWorkout
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 400)
                .foregroundStyle(color)
                .overlay {
                    if imageData != nil {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 300, height: 400)
                            .foregroundStyle(.black)
                            .overlay {
                                Image(uiImage: .init(data: imageData!)!)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }

                    }
                }
            
            VStack(alignment: .leading) {
                Label(getDistance(self.workout), systemImage: "ruler")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                
                Label(getTime(self.workout), systemImage: "clock")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Label(getPace(self.workout), systemImage: "clock.arrow.circlepath")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Label(getHeart(self.workout), systemImage: "heart.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                
                Spacer()
                
                TextField("여기에 입력", text: $text, axis: .vertical)
                    .lineLimit(6)
                    .multilineTextAlignment(.leading)
                    .padding(15)
                    .frame(height: 160, alignment: .top)
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white)
                    }
            }
            .padding(15)
            .frame(height: 400)
        }
        .frame(width: 300)
    }
}
