//
//  ProvaView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 07/05/23.
//

import SwiftUI

struct EmptyView: View {
    let navigationTitle: String
    
    var body: some View {
            
                    VStack {

                    }
                    .frame(width: 200, height: 200)
                    .navigationBarTitle(navigationTitle, displayMode: .inline)
                    .overlay(
                        VStack(spacing: 10) {
                            Image(systemName: "book")
                                .font(.system(size: 70))
                            
                            Text("No lectures\nplanned here!")
                                .font(.headline)
                                .padding(.all, 10)
                                .multilineTextAlignment(.center)
                        }
                            .foregroundColor(Color("ColorText"))
                    )
                    .modifier(CardBackground())
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(navigationTitle: "Back")
    }
}

