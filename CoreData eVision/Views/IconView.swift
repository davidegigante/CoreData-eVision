//
//  IconView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 08/05/23.
//

import SwiftUI

struct IconView: View {
    var body: some View {
        VStack {
            Image("logo app-02")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.7006983010165663, saturation: 1.0, brightness: 0.335890436746988, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.7622923333960844, saturation: 1.0, brightness: 0.7680634647966869, opacity: 1.0), location: 1.0)]), startPoint: UnitPoint.bottom, endPoint: UnitPoint.top))
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
