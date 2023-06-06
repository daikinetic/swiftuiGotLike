//
//  ContentView.swift
//  swiftuiGotLikeView
//
//  Created by Daiki Takano on 2023/05/30.
//

import SwiftUI
import SwiftUISnapDraggingModifier



struct GotLikeView: View {
    
    @StateObject var GotLikeVM = GotLikeViewModel()
    @Namespace var namespace
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                Text("お相手からのいいね：\(GotLikeVM.profiles.count)")
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
                    ForEach(Array(GotLikeVM.profiles.enumerated()), id: \.element) { index, profile in
                        GridCell(
                            GotLikeVM: GotLikeVM,
                            message: profile.message,
                            nickname: profile.nickname,
                            age: profile.age,
                            residence: profile.residence,
                            index: index
                        )
                    }
                }
                .animation(.spring(), value: GotLikeVM.profiles)

            }
            .refreshable {
                await Task.sleep(1000000000)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GotLikeView()
    }
}

struct GridCell: View {
    
    @ObservedObject var GotLikeVM: GotLikeViewModel
    @ObservedObject var GridCM = GridCellModel()
    @Namespace var namespace
    
    let id = UUID()
    let message: String
    let nickname: String
    let age: Int
    let residence: String
    let index: Int

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ZStack (alignment: .topTrailing){
                    Image("blackSheet")
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
        .offset(x: GridCM.offset.x)
        .onTapGesture {
            //
        }
        .gesture(DragGesture()
            .onChanged { value in
               
                if value.translation.height < -30 || 30.0 < value.translation.height {
                    print(value.translation, "1")
                    
                    
                } else if value.translation.width < -20.0 {
                    
                    print(value.translation, "2")
                    withAnimation (.easeOut) {
                        self.GridCM.offset.x = value.location.x - 250
                        GridCM.isSwiped = true
                    }
                    
                } else if 20.0 < value.translation.width {
                    
                    print(value.translation, "3")
                    withAnimation (.easeOut) {
                        self.GotLikeVM.offset.x = value.location.x
                    }
                    
                } else {
                   
                    print(value.translation, "4")
                }
            }
                 
            .onEnded { value in
                if GridCM.isSwiped {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            GotLikeVM.itemRemove(index: index)
                            GridCM.isSwiped = false
                            print(GotLikeVM.profiles.count)
                        }
                }
            }
                 
        
        )
        
    }
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
