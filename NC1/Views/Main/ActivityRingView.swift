//
//  ActivityRingView.swift
//  NC1
//
//  Created by 문인범 on 4/20/24.
//

import SwiftUI
import HealthKitUI





struct ActivityRingView: UIViewRepresentable {
    @State var ringViewModel = RingViewModel()
    
    func makeUIView(context: Context) -> UIView {
        switch ringViewModel.modelStatus {
        case .loading, .failure:
            return UIView()
        case .success:
            return ringViewModel.ringView!
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}



