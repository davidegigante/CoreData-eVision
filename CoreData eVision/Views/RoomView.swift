//
//  RoomView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

import SwiftUI

struct RoomView: View {
    let room: Room
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .infinity), spacing: 30)], spacing: 20) {
                    ForEach(self.room.getLectures, id: \.self) { lecture in
                        LectureCard(lecture: lecture)
                    }
                }
                
            }
            .padding()
            .navigationTitle(room.getName)
        }
    }
    
}
