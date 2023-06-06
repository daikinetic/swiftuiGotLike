//
//  GotLikeViewModel.swift
//  swiftuiGotLikeView
//
//  Created by Daiki Takano on 2023/06/05.
//

import SwiftUI

class GridCellModel: ObservableObject {
    @Published var offset = CGPoint.zero
    @Published var isSwiped = false
}

class GotLikeViewModel : ObservableObject {
    @Published var profiles: [Profile] = Profiles
    @Published var deletedProfiles: [Profile] = []
    @Published var offset = CGPoint.zero
    @Published var isSwiped = false
    
    func itemRemove(index: Int) {
            print("Delete: \(profiles[index].nickname)")
            print("index: \(index)")
            _ = profiles.remove(at: index)
            _ = deletedProfiles.append(profiles[index])
            print(deletedProfiles)
    }
    
    static var Profiles = [
        Profile(nickname: "Jam", age: 22, residence: "東京"),
        Profile(nickname: "Jackson", age: 23, residence: "千葉"),
        Profile(nickname: "Johns", age: 24, residence: "東京"),
        Profile(nickname: "Jack", age: 25, residence: "千葉"),
        Profile(nickname: "Sam", age: 26, residence: "千葉"),
        Profile(nickname: "Jami", age: 27, residence: "東京"),
        Profile(nickname: "Joy", age: 28, residence: "東京"),
        Profile(nickname: "Jay", age: 29, residence: "千葉"),
        Profile(nickname: "Johnson", age: 30, residence: "東京"),
        Profile(nickname: "Hakkel", age: 31, residence: "千葉"),
        Profile(nickname: "Nan", age: 32, residence: "千葉"),
        Profile(nickname: "Nin", age: 33, residence: "東京"),
        Profile(nickname: "Him", age: 34, residence: "東京"),
        Profile(nickname: "Json", age: 35, residence: "千葉"),
        Profile(nickname: "Jasmin", age: 36, residence: "東京"),
    ]
    
}

struct Profile: Identifiable, Hashable {
    let id = UUID()
    let nickname: String
    let image: String = ""
    let message: String = "はじめまして"
    let age: Int
    let residence: String
}
