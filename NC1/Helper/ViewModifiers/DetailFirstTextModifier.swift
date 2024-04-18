//
//  DetailFirstTextModifier.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import SwiftUI

struct DetailFirstTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .semibold))
    }
}


extension View {
    func detailFirstText() -> some View {
        modifier(DetailFirstTextModifier())
    }
}
