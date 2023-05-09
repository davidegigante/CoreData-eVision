//
//  NotificationView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 09/05/23.
//

import SwiftUI

struct NotificationSettingsView: View {
    @AppStorage("startHour") private var startHour: Int = 9
    @AppStorage("startMinute") private var startMinute: Int = 0
    @AppStorage("endHour") private var endHour: Int = 17
    @AppStorage("endMinute") private var endMinute: Int = 0
    @AppStorage("interval") private var interval: Int = 120 // In minuti

    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var intervalPickerIndex = 0

    private let calendar = Calendar.current
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    private let intervals = [1, 5, 10, 15, 30, 60, 120]

    var body: some View {
        Form {
            Section(header: Text("Orario delle notifiche")) {
                DatePicker("Starting time", selection: $startTime, displayedComponents: [.hourAndMinute])
                DatePicker("Ending time", selection: $endTime, displayedComponents: [.hourAndMinute])
                }
                
                Section(header: Text("Time interval")) {
                    Picker("Intervallo", selection: $intervalPickerIndex) {
                        ForEach(0..<intervals.count) { index in
                            Text("\(intervals[index]) minutes").tag(index)
                        }
                    }
                    .frame(alignment: .center)
                }
                
                Button("Confirm") {
                    saveUserPreferences()
                }
        
        }
        .navigationTitle("Notification settings")
    }
        
        private func saveUserPreferences() {
            startHour = calendar.component(.hour, from: startTime)
            startMinute = calendar.component(.minute, from: startTime)
            endHour = calendar.component(.hour, from: endTime)
            endMinute = calendar.component(.minute, from: endTime)
            interval = intervals[intervalPickerIndex]
        }
}

