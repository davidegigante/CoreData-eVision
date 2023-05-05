//
//  BuildingCard.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct BuildingCard: View {
    let building: Building
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Image("Daco_5162122")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 130)
                .frame(maxWidth: .infinity)
            Text("Building \(building.getName)")
                .font(.title)
                .fontWeight(.bold)
            Text(building.getRoomList())
                .opacity(0.7)
                .lineLimit(1)
            if building.getRooms.count > 1 {
                Text("\(building.getRooms.count) rooms - \(building.getRooms.filter({ $0.isFreeNow() }).count) available")
                    .opacity(0.7)
            } else {
                Text("\(building.getRooms.count) room - \(building.getRooms.filter({ $0.isFreeNow() }).count) available")
                    .opacity(0.7)
            }
        }
        .foregroundColor(.white)
        .padding(16)
        .frame(width: 252, height: 300)
        .background(String.useGradient(for: building.getName))
        .cornerRadius(30.0)
    }
    
    
}
