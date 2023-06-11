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
    
    @StateObject var gotLikeVM = GotLikeViewModel()
    @State var isBoldCount: Bool = false
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                
                HStack (spacing: 0) {
                    Text("お相手からのいいね：")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                    Text("\(gotLikeVM.profiles.count)")
                        .font(.system(size: isBoldCount ? 18 : 15, weight: isBoldCount ? .heavy : .regular))
                            .foregroundColor(.white)
                }
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
                LazyVGrid (columns: columns, spacing: 14){
                    ForEach(Array(gotLikeVM.profiles.enumerated()), id: \.element) { index, profile in
                        GridCell(
                            gotLikeVM: gotLikeVM,
                            message: profile.message,
                            nickname: profile.nickname,
                            age: profile.age,
                            residence: profile.residence,
                            image: profile.image,
                            index: index,
                            isBoldCount: $isBoldCount
                        )
                    }
                }
                .animation(.spring(), value: gotLikeVM.profiles)
                .padding(.horizontal, 20)
                
            }
            .frame(maxHeight: .infinity)
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
    
    @ObservedObject var gotLikeVM: GotLikeViewModel
    
    let id = UUID()
    let message: String
    let nickname: String
    let age: Int
    let residence: String
    var image: String
    let index: Int
    
    @State var currentOffset: CGSize = .zero
    @GestureVelocity private var velocity: CGVector
    @State var isRotate: Bool = false
    @State var isFrontItem: Bool = false
    @State var isLeftSwipe: Bool = false
    @Binding var isBoldCount: Bool
    
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
            .overlay(alignment: .topTrailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 155.5, height: 220)
                        .foregroundColor(.white.opacity(0))
                        .background(
                            isLeftSwipe ?
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(0x000000).opacity(0.5),Color(0x000000).opacity(0)]),
                                    startPoint: .init(x: 1, y: 0),    // start地点
                                    endPoint: .init(x: 0, y: 1)     // end地点
                                )
                            :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(0x00C1D4).opacity(1),Color(0x00C1D4).opacity(0)]),
                                    startPoint: .init(x: 0, y: 0),    // start地点
                                    endPoint: .init(x: 1, y: 1)     // end地点
                                ))
                        .cornerRadius(20, style: .continuous)
                    
                    Image(isLeftSwipe ? "nope" : "like")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width: isLeftSwipe ? 36 : 34)
                        .foregroundColor(isLeftSwipe ? Color(0x96AAAA) : .white)
                        .offset(
                            x: isLeftSwipe ? 30 : -32,
                            y: isLeftSwipe ? -85 : -80)
                        .rotationEffect(Angle(degrees: isLeftSwipe ? 10 : -8))
                }
                .opacity(isRotate ? getOverlayAmount() : 0)
            }
            
            VStack (spacing: 0){
                Text(nickname)
                    .padding(.top, 8)
                    .fontWeight(.bold)
                    .font(.system(size: 14, weight: .heavy))
                    .padding(.bottom, 4)
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
                .padding(.bottom, 8)
            }

        }
        .background(
            .white.opacity(0.9)
        )
        .cornerRadius(20, style: .continuous)
        .offset(currentOffset)
        .rotationEffect(isRotate ? Angle(degrees: getRotationAmount()) : Angle(degrees: 0))
        .zIndex(isFrontItem ? 8 : 0)
        
        .onTapGesture {
            //
        }
        .gesture(DragGesture()
            .onChanged { value in
                
                currentOffset = value.translation
                isRotate = true
                isFrontItem = true
                if currentOffset.width < 0{
                    isLeftSwipe = true
                } else {
                    isLeftSwipe = false
                }
            }
                 
            .onEnded { value in
                
                let distance = CGSize(
                    width: currentOffset.width,
                    height: currentOffset.height
                )
                
                let mappedVelocity = CGVector(
                    dx: velocity.dx / distance.width,
                    dy: velocity.dy / distance.height
                )
                
                let screenWidth = UIScreen.main.bounds.width
                
                let mass: Double = 1
                let stiffness: Double = 50
                let damping: Double = 20
                
                // x方向のアニメーション
                withAnimation(.interpolatingSpring(
                    mass: mass,
                    stiffness: stiffness,
                    damping: damping,
                    initialVelocity: mappedVelocity.dx
                )) {
                    
                    print("velocity: \(velocity)")
                    print("mappedVelocity \(mappedVelocity)")
                    
                    if value.predictedEndTranslation.width < -1 * screenWidth / 3 {
                        
                        currentOffset.width = value.predictedEndTranslation.width * 2
                        isBoldCount = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            gotLikeVM.itemRemove(index: index)
                            isBoldCount = false
                        }
                    } else if value.predictedEndTranslation.width > 1 * screenWidth / 3 {
                        
                        currentOffset.width = value.predictedEndTranslation.width * 2
                        isBoldCount = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            gotLikeVM.itemRemove(index: index)
                            isBoldCount = false
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
                    mass: mass,
                    stiffness: stiffness,
                    damping: damping,
                    initialVelocity: mappedVelocity.dy
                )) {
                    
                    if value.predictedEndTranslation.width < -1 * screenWidth / 3 {
                        
                        currentOffset.height = value.predictedEndTranslation.height * 2
                        
                    } else if value.predictedEndTranslation.width > 1 * screenWidth / 3 {
                        
                        currentOffset.height = value.predictedEndTranslation.height * 2
                        
                    }
                }
                
            }
            .updatingVelocity($velocity)
                 
        )
    }
    
    private func getOverlayAmount() -> Double {
        withAnimation (.spring()) {
            let max = UIScreen.main.bounds.width / 4
            let currentAmount = abs(currentOffset.width)
            let percentage = currentAmount / max
            let percentageAsDouble = Double(percentage)
            let maxAngle: Double = 1
            
//            if currentOffset.width > 0 {
//                return 0
//            } else
            if percentage < 1 {
                return percentageAsDouble * maxAngle
            } else {
                return 1
            }
        }
        
    }
    
    private func getRotationAmount() -> Double {
        withAnimation (.spring()) {
            let max = UIScreen.main.bounds.width / 4
            let currentAmount = abs(currentOffset.width)
            let percentage = currentAmount / max
            let percentageAsDouble = Double(percentage)
            let maxAngle: Double = 12
            
            if currentOffset.width > 0 {
                if percentage < 1 {
                    return percentageAsDouble * maxAngle
                } else {
                    return 12
                }
            } else {
                if percentage < 1 {
                    return percentageAsDouble * maxAngle * -1
                } else {
                    return -12
                }
            }
            
//            if currentOffset.width > 0 {
//                return 0
//            } else if percentage < 1 {
//                return percentageAsDouble * maxAngle * -1
//            } else {
//                return -12
//            }
        }
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
