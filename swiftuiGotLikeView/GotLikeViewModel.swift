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
    @State var disableDownloads: Bool = false
    
    func itemRemove(index: Int) {
            print("Delete: \(profiles[index].nickname)")
            print("index: \(index)")
            _ = profiles.remove(at: index)
            _ = deletedProfiles.append(profiles[index])
            print(deletedProfiles)
    }
    
    private func downloadImage(_ url: URL) {
        disableDownloads = true
        Task.detached {
          let (data, _) = try await URLSession.shared.data(
            from: url
          )
          let image: UIImage = try .init(data: data)!
          if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(3))
          }
          else {
            try await Task.sleep(nanoseconds: .init(3 * 1_000_000_000))
          }
          await MainActor.run {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
              self.disableDownloads = false
          }
        }
      }
    
    
//        var list = []
//        for i in 0...14 {
//            var item = downloadImage(URL(string: "https://source.unsplash.com/random/?woman,female,portrait")!)
//            list.append(item)
//        }
    
    static var Profiles = [
        Profile(nickname: "さえこ", age: 22, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Jackson", age: 23, residence: "千葉", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Johns", age: 24, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Jack", age: 25, residence: "千葉", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Sam", age: 26, residence: "千葉", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Jami", age: 27, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Joy", age: 28, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Jay", age: 29, residence: "千葉", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Johnson", age: 30, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portraitb"),
        Profile(nickname: "Hakkel", age: 31, residence: "千葉", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Nan", age: 32, residence: "千葉", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Nin", age: 33, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Him", age: 34, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Json", age: 35, residence: "千葉", image: "https://source.unsplash.com/random/?woman,female,portrait"),
        Profile(nickname: "Jasmin", age: 36, residence: "東京", image: "https://source.unsplash.com/random/?woman,female,portrait"),
    ]
    
}

struct Profile: Identifiable, Hashable {
    let id = UUID()
    let nickname: String
    let message: String = "はじめまして"
    let age: Int
    let residence: String
    let image: String
}




