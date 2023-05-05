//
//  SmallBuildingCard.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct SmallBuildingCard: View {
    let building: Building
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Image("Daco_5162122")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 99)
                .frame(maxWidth: .infinity)
            Text("Building \(building.getName)")
                .font(.headline)
                .fontWeight(.bold)
            //                .blendMode(.overlay)
            if building.getRooms.count > 1 {
                Text("\(building.getRooms.count) rooms")
                    .opacity(0.7)
            } else {
                Text("\(building.getRooms.count) room")
                    .opacity(0.7)
            }
            Text("\(building.getRooms.filter({ $0.isFreeNow() }).count) available")
                .opacity(0.7)
        }
        .foregroundColor(.white)
        .padding(16)
        .frame(height: 222)
        .background(String.useGradient(for: building.getName))
        .cornerRadius(30.0)
    }
}



