//
//  LoadingView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geometry in
            Loader()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
    }
}

struct Loader : View {
    
    @State var animate = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [.red,.orange]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .onAppear() {
                    withAnimation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                        self.animate = true
                    }
                }
                .padding(.top, 10)
            
            Text("Fetching data...")
                .padding()
        }
        .background(Color("CardBackground"))
        .cornerRadius(15)
        .onAppear {
            self.animate.toggle()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
