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
            Text("It seems that you did not choose any building as favourite!")
                .opacity(0.7)
                .lineLimit(3)
        }
        .foregroundColor(.white)
        .padding(16)
        .frame(width: 252, height: 300)
        .background(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.0027002541415662652, saturation: 1.0, brightness: 0.537782967808735, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.0, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9997596153846153)]), startPoint: UnitPoint.bottomLeading, endPoint: UnitPoint.topTrailing))
        .cornerRadius(30.0)
    }
}


struct OpsCard_Previews: PreviewProvider {
    static var previews: some View {
        OopsCard()
    }
}
