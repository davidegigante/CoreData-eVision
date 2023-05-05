//
//  LectureCard.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct LectureCard: View {
    let lecture: Lecture
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        return df
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(lecture.getName)
                    .bold()
                    .lineLimit(1)
                
                Text(lecture.getType).foregroundColor(Color("ColorText"))
                Text("\(lecture.getStartingTime, formatter: DateFormatter.timeOnly()) - \(lecture.getEndingTime, formatter: DateFormatter.timeOnly())")
                    .font(.subheadline)
                    .foregroundColor(Color("ColorText")).opacity(0.7)
                    .lineLimit(1)
                
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(self.lecture.getProfessors, id: \.self) { professor in
                        HStack {
                            Text("\(String(professor.getName.prefix(1))). \(professor.getSurname) (\(professor.getMail))")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(Color("ColorText")).opacity(0.7)
                    .lineLimit(1)
                }
            }
            .padding()
            Spacer()
        }
        .modifier(CardBackground())
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
}





