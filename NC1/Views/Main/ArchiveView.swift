//
//  ArchiveView.swift
//  NC1
//
//  Created by 문인범 on 4/18/24.
//

import SwiftUI


struct ArchiveView: View {
    let iconColor: Color = Color(red: 254/255, green: 98/255, blue: 98/255)
    let count: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .frame(height: 100)
            
            HStack(spacing: 10) {
                Text("보관함")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Text("\(count)개의 기록")
                    .font(.system(size: 14, weight: .regular))
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 40)
                    .foregroundStyle(iconColor)
            }
            .padding(.horizontal, 25)
        }
    }
}
