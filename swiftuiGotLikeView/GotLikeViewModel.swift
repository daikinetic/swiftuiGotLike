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
    @Published var offset = CGPoint.zero
    @Published var isSwiped = false
    
    func itemRemove(index: Int) {
        print("Delete: \(profiles[index].nickname)")
        _ = profiles.remove(at: index)
    }
    
    static var Profiles = [
        Profile(nickname: "James", age: 22, residence: "東京"),
        Profile(nickname: "Jackson", age: 24, residence: "千葉"),
        Profile(nickname: "James", age: 22, residence: "東京"),
        Profile(nickname: "Jackson", age: 24, residence: "千葉"),
        Profile(nickname: "Jackson", age: 24, residence: "千葉"),
        Profile(nickname: "James", age: 22, residence: "東京"),
        Profile(nickname: "James", age: 22, residence: "東京"),
        Profile(nickname: "Jackson", age: 24, residence: "千葉"),
        Profile(nickname: "James", age: 22, residence: "東京"),
        Profile(nickname: "Jackson", age: 24, residence: "千葉"),
        Profile(nickname: "Jackson", age: 24, residence: "千葉"),
        Profile(nickname: "James", age: 22, residence: "東京"),
        Profile(nickname: "James", age: 22, residence: "東京"),
        Profile(nickname: "Jackson", age: 24, residence: "千葉"),
        Profile(nickname: "James", age: 22, residence: "東京"),
        
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
