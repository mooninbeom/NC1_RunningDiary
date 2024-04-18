//
//  AddingDiaryView.swift
//  NC1
//
//  Created by 문인범 on 4/15/24.
//

import SwiftUI
import HealthKit
import RealmSwift
import PhotosUI
import UIKit


struct AddingDiaryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isActionPresented: Bool = false
    @State private var isSheetPresented: Bool = false
    @State private var isPhotosPickerPresented: Bool = false
    @State private var color: Color = Color(red: 1, green: 171/255, blue: 171/255)
    @State private var text: String = ""
    @State private var pickedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    
    
    let workout: HKWorkout
    
    var body: some View {

        VStack {
            DiaryImageView(text: $text, imageData: $imageData, color: $color, workout: workout)
            
            
            
            HStack {
                Button {
                    isActionPresented = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 50)
                            .foregroundStyle(Color(red: 1, green: 174/255, blue: 115/255))
                        
                        Text("사진 수정")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                ColorPicker("", selection: $color)
                    .labelsHidden()
                
                Spacer()
                
                Button {
                    isSheetPresented = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 50)
                            .foregroundStyle(Color(red: 164/255, green: 206/255, blue: 1))
                        
                        Text("자세히...")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
            }
            
            
            Spacer()
            
        }
        .navigationTitle(getDate())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("저장") {
                    saveArchive()
                }
            }
        }
        .confirmationDialog("사진 수정", isPresented: $isActionPresented) {
            Button("앨범에서 가져오기", role: .none) {
                self.isPhotosPickerPresented.toggle()
            }
            
            Button("기본 이미지로 변경", role: .none) {
                self.pickedPhoto = nil
                self.imageData = nil
            }
            
            Button("취소", role: .cancel) {
                isActionPresented = false
            }
            
        }
        .sheet(isPresented: $isSheetPresented) {
            WorkoutDetailView(workout: self.workout)
        }
        .photosPicker(isPresented: $isPhotosPickerPresented, selection: $pickedPhoto, matching: .images)
        .onChange(of: pickedPhoto) {
            getPhoto()
        }
    }
    
    private func getDate() -> String {
        let date = self.workout.endDate
        let format = "yyyy년 MM월 dd일"
        let result = date.dateToString(format: format)
        return result
    }
    
    @MainActor 
    private func saveArchive() {
        let diary = ArchiveModel()
        let result: (Color?, Data?)
        
        if let data = self.imageData {
            result = (nil, data)
        } else {
            result = (self.color, nil)
        }
        
        let imageView = SnapshotView(color: result.0, imageData: result.1, distance: getDistance(self.workout), time: getTime(self.workout), pace: getPace(self.workout), heart: getHeart(self.workout), text: self.text)
        
        let snapshot = imageView.snapshot()
        
        if let data = snapshot.pngData() {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documents.appending(path: "\(self.workout.uuid).png")
            
            do {
                try data.write(to: url)
                diary.image = url.absoluteString
                print("save success!")
            } catch {
                fatalError()
            }
        } else {
            return
        }
        
        diary.savedDate = workout.startDate
        diary.id = UUID()
        diary.workout = workout.uuid
        diary.text = text
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day], from: workout.startDate)
        diary.year = comp.year!
        diary.month = comp.month!
        diary.day = comp.day!
        
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(diary)
        }
        
        dismiss()
    }
}


// View to UIImage
extension View {
    
    @MainActor
    public func snapshot() -> UIImage {        
        let renderer = ImageRenderer(content: self)
        renderer.scale = UIScreen.main.scale
        
        guard let image = renderer.uiImage else {
            return UIImage()
        }
        
        return image
    }
}


extension AddingDiaryView {
    func getPhoto() {
        if pickedPhoto == nil {
            return
        }
        
        self.pickedPhoto!.loadTransferable(type: Data.self) { (result: Result<Data?, Error>) in
            switch result {
            case .success(let success):
                self.imageData = success
            case .failure(_):
                fatalError()
            }
        }
    
        
    }
}
