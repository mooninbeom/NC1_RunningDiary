//
//  GrayTwoModifier.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI

struct GrayTwoModifier: ViewModifier {
    let grayTwo: Color = .init(red: 137/255, green: 137/255, blue: 137/255)

    func body(content: Content) -> some View {
        content
            .frame(width: 150, height: 70)
            .foregroundStyle(grayTwo)
    }
}



extension View {
    func grayTwo() -> some View {
        modifier(GrayTwoModifier())
    }
}

