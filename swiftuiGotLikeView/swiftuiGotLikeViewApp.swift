//
//  swiftuiGotLikeViewApp.swift
//  swiftuiGotLikeView
//
//  Created by Daiki Takano on 2023/05/30.
//

import SwiftUI

@main
struct swiftuiGotLikeViewApp: App {
    @StateObject private var GotLikeVM = GotLikeViewModel()
    
    var body: some Scene {
        WindowGroup {
            GotLikeView()
                .environmentObject(GotLikeVM)
        }
    }
}
