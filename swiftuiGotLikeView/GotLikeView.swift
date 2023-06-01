//
//  ContentView.swift
//  swiftuiGotLikeView
//
//  Created by Daiki Takano on 2023/05/30.
//

import SwiftUI
import SwiftUISnapDraggingModifier

struct GotLikeView: View {
    
    @State var touchPointCenter = CGPoint.zero
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @State var profiles: [Profile] = MockStore.Profiles
    
    @State private var allowsHitTesting = true

    
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                Text("お相手からのいいね：\(profiles.count)")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 10, leading: 28, bottom: 10, trailing: 28))
                    .background(.gray)
                    .cornerRadius(20)
                Spacer()
                Image(systemName: "line.3.horizontal")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
            .padding(.bottom, 15)
            .padding(.horizontal, 15)
            
            ScrollView (.vertical, showsIndicators: false) {
                LazyVGrid (columns: columns, spacing: 24){
                    ForEach(profiles, id:\.id) { profile in
                        GridCell(message: profile.message, nickname: profile.nickname, age: profile.age, residence: profile.residence)
                            .offset(x: touchPointCenter.x)
                            .onTapGesture {
                                allowsHitTesting = true
                            }
                            .gesture(DragGesture()
                                .onChanged { value in
                                    allowsHitTesting = true
                                    if value.translation.height > 30.0 {
                                        print(value.translation)
                                        allowsHitTesting = false
                                        print(allowsHitTesting)
                                    } else if value.translation.width < -20.0 || 20.0 < value.translation.width {
                                        print(value.translation)
                                        withAnimation (.easeOut) {
                                            self.touchPointCenter.x = value.location.x
                                        }
                                        print(allowsHitTesting)
                                    } else {
                                        allowsHitTesting = true
                                        print(allowsHitTesting)
                                    }
                                })
                            .allowsHitTesting(allowsHitTesting)
                            
                            
                    }
                    
                }
            }
            .refreshable {
                await Task.sleep(1000000000)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
    
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                self.completedLongPress = finished
            }
    }
    
    func itemRemove(id: UUID) {
        for (i, profile) in profiles.enumerated() {
            if profile.id == id {
                print("Delete: \(profiles[i].nickname)")
                profiles.remove(at: i)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GotLikeView()
    }
}

struct GridCell: View {
    let message: String
    let nickname: String
    let age: Int
    let residence: String
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ZStack (alignment: .topTrailing){
                    Image("a")
                        .resizable()
                        .aspectRatio( 160/225, contentMode: .fill)
                        .cornerRadius(20)
                        .frame(width: 160, height: 225)
                    
                    Image(systemName: "star")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width: 18, height: 18)
                        .foregroundColor(.white)
                        .padding(.top, 12)
                        .padding(.trailing, 12)
                }
                Text(message)
                    .frame(width:130)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(.pink)
                    .cornerRadius(16)
                    .padding(.bottom, 10)
                    .font(.callout)
            }
            
            VStack {
                Text(nickname)
                    .padding(.bottom, -5)
                    .fontWeight(.bold)
                    .font(.callout)
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                    Text("\(age)歳")
                        .foregroundColor(.gray)
                        .font(.callout)
                    Text(residence)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
            }
        }
        
    }
}



struct Profile: Identifiable {
    let id = UUID()
    let nickname: String
    let image: String = ""
    let message: String = "はじめまして"
    let age: Int
    let residence: String
}

struct MockStore {
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


extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct RefreshableModifier: ViewModifier {
    let action: @Sendable () async -> Void
    
    func body(content: Content) -> some View {
        List {
            HStack {
                Spacer()
                content
                Spacer()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .refreshable (action: action)
        .listStyle(PlainListStyle())
    }
}

extension ScrollView {
    func refreshable(action: @escaping @Sendable () async -> Void) -> some View {
        modifier(RefreshableModifier(action: action))
    }
}

private func sampleFunc() {
    print("aaa")
}
