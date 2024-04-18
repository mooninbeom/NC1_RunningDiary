//
//  DetailSecondTextModifier.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI

struct DetailSecondTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 20, weight: .semibold))
    }
}


extension View {
    func detailSecondText() -> some View {
        modifier(DetailSecondTextModifier())
    }
}
