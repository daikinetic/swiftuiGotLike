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
        Profile(nickname: "さえこ", age: 22, residence: "東京", image: "https://images.unsplash.com/photo-1508216310976-c518daae0cdc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTQ4Ng&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Jackson", age: 23, residence: "千葉", image: "https://images.unsplash.com/photo-1472849676747-48a51c0c30b6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTUzMw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Johns", age: 24, residence: "東京", image: "https://images.unsplash.com/photo-1541519481457-763224276691?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTU2Mg&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Jack", age: 25, residence: "千葉", image: "https://images.unsplash.com/photo-1531256456869-ce942a665e80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTU5OQ&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Sam", age: 26, residence: "千葉", image: "https://github.com/daikinetic/numeron/assets/97176797/df504c25-a99b-465c-8322-e3d459af8d30"),
        Profile(nickname: "Jami", age: 27, residence: "東京", image: "https://github.com/daikinetic/numeron/assets/97176797/95b1a2eb-ea76-4d24-9b20-e7841b30f579"),
        Profile(nickname: "Joy", age: 28, residence: "東京", image: "https://github.com/daikinetic/numeron/assets/97176797/a4030c13-eefe-437f-9b3a-e43c4e162178"),
        Profile(nickname: "Jay", age: 29, residence: "千葉", image: "https://github.com/daikinetic/numeron/assets/97176797/74acbd22-07b4-4cfa-ad68-cdd62ad6c472"),
        Profile(nickname: "Johnson", age: 30, residence: "東京", image: "https://images.unsplash.com/photo-1536296621180-13f4d1eabac9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTc5OA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Hakkel", age: 31, residence: "千葉", image: "https://images.unsplash.com/photo-1512646605205-78422b7c7896?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTc4MQ&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Nan", age: 32, residence: "千葉", image: "https://images.unsplash.com/photo-1519872775884-29a6fea271ca?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTcxNg&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Nin", age: 33, residence: "東京", image: "https://images.unsplash.com/photo-1469504484373-b23e7ba83aa5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTcwMw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Him", age: 34, residence: "東京", image: "https://images.unsplash.com/photo-1532170579297-281918c8ae72?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTY3OA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Json", age: 35, residence: "千葉", image: "https://images.unsplash.com/photo-1591089079607-73a2d0343394?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTY1Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
        Profile(nickname: "Jasmin", age: 36, residence: "東京", image: "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8d29tYW4sZmVtYWxlLHBvcnRyYWl0fHx8fHx8MTY4NjEwOTYzMw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080"),
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




