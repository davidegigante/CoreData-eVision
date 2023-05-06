//
//  OpsCard.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct OopsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Image(systemName: "hand.tap")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 130)
                .frame(maxWidth: .infinity)
            Text("Oooops!")
                .font(.title)
                .fontWeight(.bold)
            Text("It seems that you do not choose any building as favourite!")
                .opacity(0.7)
                .lineLimit(3)
        }
        .foregroundColor(.white)
        .padding(16)
        .frame(width: 252, height: 300)
        .background(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.7674369352409639, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 1.0, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 1.0)]), startPoint: UnitPoint.bottom, endPoint: UnitPoint.top))
        .cornerRadius(30.0)
    }
}


struct OpsCard_Previews: PreviewProvider {
    static var previews: some View {
        OopsCard()
    }
}
