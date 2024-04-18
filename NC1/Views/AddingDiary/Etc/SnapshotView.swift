//
//  SnapshotView.swift
//  NC1
//
//  Created by 문인범 on 4/18/24.
//

import SwiftUI


struct SnapshotView: View {
    let color: Color?
    let imageData: Data?
    
    let distance: String
    let time: String
    let pace: String
    let heart: String
    let text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 400)
                .foregroundStyle(color ?? .black)
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
                Label(self.distance, systemImage: "ruler")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Label(self.time, systemImage: "clock")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Label(self.pace, systemImage: "clock.arrow.circlepath")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Label(self.heart, systemImage: "heart.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                
                Spacer()
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                        .frame(height: 160)
                        .foregroundStyle(.white)
                        .background {
                            Text(text)
                                .padding(15)
                                .frame(maxWidth: 300, maxHeight: 160, alignment: .topLeading)
                                .foregroundStyle(.white)
                        }
                }
            }
            .padding(15)
            .frame(height: 400)
        }
        .frame(width: 300)
    }
}
