//
//  AlbumDayView.swift
//  NC1
//
//  Created by 문인범 on 4/18/24.
//



import SwiftUI
import RealmSwift



struct AlbumDayView: View {
    @Binding var status: ArchiveStatus
    @Binding var isEditing: Bool
    @State private var isLongPressed: Bool = false
    
    let models: Results<ArchiveModel>
    
    @State var selectedArchive: ArchiveModel?
    
    var body: some View {
        VStack {
            ForEach(models) { model in
                VStack {
                    HStack {
                        Text(model.savedDate.dateToString(format: "yyyy년 MM월 dd일"))
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    getModelImage(model.image)
                        .scaledToFit()
                        .padding(15)
                        .shadow(radius: 10)
                        .onTapGesture {
                            
                        }
                        .onLongPressGesture {
                            self.selectedArchive = model
                            isLongPressed.toggle()
                        }
                        
                }
                .padding(.bottom, 20)

            }
        }
        .confirmationDialog("삭제하시겠습니까?", isPresented: $isLongPressed) {
            Button("삭제하기", role: .destructive) {
                guard let model = self.selectedArchive else {
                    return
                }
                
                let realm = try! Realm()
                
                try! realm.write {
                    if let delRow = realm.object(ofType: ArchiveModel.self, forPrimaryKey: model.id) {
                        realm.delete(delRow)
                    }
                }
            }
            
            Button("취소", role: .cancel) {
                self.isLongPressed = false
            }
        }
    }
}
