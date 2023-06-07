//
//  ContentView.swift
//  swiftuiGotLikeView
//
//  Created by Daiki Takano on 2023/05/30.
//

import SwiftUI
import SwiftUIGestureVelocity
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
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 10, leading: 28, bottom: 10, trailing: 28))
                    .background(Color(0x00AEC2))
                    .cornerRadius(20)
                    .padding(.leading, 10)
                Spacer()
                Image("detail-pairs")
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 10)
                
            }
            .padding(.bottom, 15)
            .padding(.horizontal, 24)
            
            ScrollView (.vertical, showsIndicators: false) {
                LazyVGrid (columns: columns, spacing: 24){
                    ForEach(Array(GotLikeVM.profiles.enumerated()), id: \.element) { index, profile in
                        GridCell(
                            GotLikeVM: GotLikeVM,
                            message: profile.message,
                            nickname: profile.nickname,
                            age: profile.age,
                            residence: profile.residence,
                            image: profile.image,
                            index: index
                        )
                    }
                }
                .animation(.spring(), value: GotLikeVM.profiles)
                .padding(.horizontal, 20)
                
            }
            .refreshable {
                await Task.sleep(1000000000)
            }
        }
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
    var image: String
    let index: Int
    
    @State var currentOffset: CGSize = .zero
    @GestureVelocity private var velocity: CGVector
    @State var disableDownloads: Bool = false
    @State var isRotate: Bool = false
    @State var isFrontItem: Bool = false
    
    var body: some View {
        VStack(spacing: 0){
            ZStack(alignment: .bottom) {
                ZStack (alignment: .topTrailing){
                    AsyncImage(url: URL(string: image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(155.5/220, contentMode: .fit)
                    .cornerRadius(20)
                    .frame(width: 155.5, height: 220)
                    
                    Image("star-pairs")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(height: 16)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.trailing, 9)
                }
                Text(message)
                    .frame(width:130)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(0xFF8F87),Color(0xFC6675)]),
                            startPoint: .init(x: -0.8, y: -0.8),    // start地点
                            endPoint: .init(x: 0.7, y: 0.7)     // end地点
                        ))
                    .cornerRadius(16)
                    .padding(.bottom, 8)
                    .font(.system(size: 14, weight: .bold))
            }
            .padding(.bottom, 8)
            
            VStack (spacing: 0){
                Text(nickname)
                    .padding(.bottom, -5)
                    .fontWeight(.bold)
                    .font(.system(size: 14, weight: .heavy))
                    .padding(.bottom, 6)
                HStack(spacing: 4){
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(0x56C076))
                    Text("\(age)歳")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .regular))
                    Text(residence)
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .regular))
                }
            }
        }
        .offset(currentOffset)
        .rotationEffect(isRotate ? Angle(degrees: -8) : Angle(degrees: 0))
        .zIndex(isFrontItem ? 8 : 0)
        
        .onTapGesture {
            //
        }
        .gesture(DragGesture()
            .onChanged { value in
                
                currentOffset = value.translation
                isRotate = true
                isFrontItem = true
            }
                 
            .onEnded { value in
                
                let distance = CGSize(
                    width: -currentOffset.width,
                    height: -currentOffset.height
                )
                
                let mappedVelocity = CGVector(
                    dx: velocity.dx / distance.width,
                    dy: velocity.dy / distance.height
                )
                
                // x方向のアニメーション
                withAnimation(.interpolatingSpring(
                    mass: 1, stiffness: 50, damping: 20, initialVelocity: mappedVelocity.dx)) {
                        
                        print("velocity: \(velocity)")
                        
                        let screenWidth = UIScreen.main.bounds.width
                        
                        if velocity.dx < -150 {
                            // swipe 実行条件①：velocity　 TODO：実機検証で数字を調整
                            
                            //「予想される移動距離」と「画面サイズの半分」のうち、大きい方を採用
                            if -value.predictedEndTranslation.width > screenWidth/2 {
                                
                                currentOffset.width = value.predictedEndTranslation.width
                                
                            } else {
                                currentOffset.width = currentOffset.width - (screenWidth/2 + 100)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                GotLikeVM.itemRemove(index: index)
                            }
                            
                        } else if screenWidth/2 < -currentOffset.width {
                            // swipe 実行条件②：アイテムを離した時の currentOffset
                            
                            currentOffset.width = (currentOffset.width - (screenWidth/2 + 100))
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                GotLikeVM.itemRemove(index: index)
                            }
                            
                        } else {
                            // cancel
                            currentOffset = .zero
                            isRotate = false
                            isFrontItem = false
                            
                        }
                    }
                
                // y方向のアニメーション
                withAnimation(.interpolatingSpring(
                    mass: 1, stiffness: 50, damping: 20, initialVelocity: mappedVelocity.dx)) {
                        
                        let screenHeight = UIScreen.main.bounds.height
                        
                        if velocity.dx < -150 { // swipe 実行条件
                            
                            if abs(value.predictedEndTranslation.height) > screenHeight/2 {
                                currentOffset.height = value.predictedEndTranslation.height
                                
                            } else {
                                currentOffset.height = currentOffset.height - screenHeight/2
                                
                            }
                            
                        }
                    }
                
            }
            .updatingVelocity($velocity)
                 
        )
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

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
