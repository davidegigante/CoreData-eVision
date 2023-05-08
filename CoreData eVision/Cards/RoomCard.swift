//
//  RoomCard.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct RoomCard: View {
    let room: Room
    
    var body: some View {
        HStack {
            String.useImage(for: room.getName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.all)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(room.getName)
                    .bold()
                    .foregroundColor(Color("ColorText"))
                    .lineLimit(1)
                    if room.isFreeNow() {
                        Text("Free")
                            .foregroundColor(.green)
                            .font(.subheadline)

                    } else {
                        Text("Unavailable")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
            .padding()
            
            Spacer()
            Image(systemName: "chevron.right")
                .padding(.all)
            
        }
        .modifier(CardBackground())
    }
    
}

// view modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("CardBackground"))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 4)
    }
}
