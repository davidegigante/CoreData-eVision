//
//  Utils+.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

import Foundation
import SwiftUI

extension DateFormatter {
    
    static func timeOnly() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
}

extension String {
    func extractName() -> String? {
        let pattern = #"Edificio (\w+)"#
        if let range = self.range(of: pattern, options: .regularExpression) {
            return String(self[range].dropFirst("Edificio ".count))
        } else {
            return nil
        }
    }
    
    static func useGradient(for buildingName: String) -> LinearGradient {
        switch buildingName.first {
        case "A":
            return LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.5765748541039157, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.5080889966114458, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9997596153846153)]), startPoint: UnitPoint.bottomLeading, endPoint: UnitPoint.topTrailing)
        case "B":
            return LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.0941823936370482, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 1.0, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9997596153846153)]), startPoint: UnitPoint.bottomLeading, endPoint: UnitPoint.topTrailing)
        case "C":
            return LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.3090202607304217, saturation: 1.0, brightness: 0.8, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.44886871705572295, saturation: 1.0, brightness: 0.8, opacity: 1.0), location: 1.0)]), startPoint: UnitPoint.topTrailing, endPoint: UnitPoint.bottomLeading)
        case "D":
            return LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.0027002541415662652, saturation: 1.0, brightness: 0.537782967808735, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.0, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9997596153846153)]), startPoint: UnitPoint.bottomLeading, endPoint: UnitPoint.topTrailing)
        case "E":
            return LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.6458725527108434, saturation: 1.0, brightness: 0.8, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.5383389024849398, saturation: 1.0, brightness: 0.8, opacity: 1.0), location: 1.0)]), startPoint: UnitPoint.topTrailing, endPoint: UnitPoint.bottomLeading)
        case "F":
            return LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.0877406108810241, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.1512054075677711, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9997596153846153)]), startPoint: UnitPoint.bottomLeading, endPoint: UnitPoint.topTrailing)
        default:
            return LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.746046686746988, saturation: 1.0, brightness: 0.8, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.8650431805346386, saturation: 1.0, brightness: 0.8, opacity: 1.0), location: 1.0)]), startPoint: UnitPoint.topTrailing, endPoint: UnitPoint.bottomTrailing)
        }
        
    }
}

extension Date {
    
    static func stringToTime(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateString = String(format: "%04d-%02d-%02d %@", components.year!, components.month!, components.day!, string)
        let date = dateFormatter.date(from: dateString)
        
        // Aggiungi due ore alla data
        // date = calendar.date(byAdding: .hour, value: 2, to: date!)
        
        return date
    }


    // Utility function
    static func getCurrentDateFormatted() -> String {
        // Ottieni la data attuale nel formato "GG-MM-AAAA"
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        // Restituisci la data formattata
        return formattedDate
    }
}


