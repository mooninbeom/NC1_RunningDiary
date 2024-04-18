//
//  NC1App.swift
//  NC1
//
//  Created by 문인범 on 4/12/24.
//

import SwiftUI
import RealmSwift

@main
struct NC1App: SwiftUI.App {
    var body: some Scene {
//        let realm = try! Realm(configuration: .init(deleteRealmIfMigrationNeeded: true))
        
        WindowGroup {
            MainView()
        }
    }
}
