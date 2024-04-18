//
//  ArchiveModel.swift
//  NC1
//
//  Created by 문인범 on 4/16/24.
//

import Foundation
import HealthKit
import RealmSwift
import CoreLocation
import UIKit

//struct ArchiveModel: Identifiable {
//    let id = UUID()
//    
//    let savedDate: Date
//    let workout: HKWorkout
//    
//    var text: String
//}


class ArchiveModel: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var savedDate: Date
    @Persisted var workout: UUID
    @Persisted var text: String
    @Persisted var image: String
    
    @Persisted var year: Int
    @Persisted var month: Int
    @Persisted var day: Int
}


extension ArchiveModel {

    
//    func findAll() -> Results<ArchiveModel> {
//        
//    }
    
//    func deleteAll() {
//        let real = try! Realm()
//        
//        try! real.write {
//            realm?.deleteAll()
//        }
//    }
}
