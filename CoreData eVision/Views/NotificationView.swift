//
//  NotificationView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 09/05/23.
//

import SwiftUI
import CoreData
import UserNotifications

struct NotificationSettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("startHour") private var startHour: Int = 9
    @AppStorage("startMinute") private var startMinute: Int = 0
    @AppStorage("endHour") private var endHour: Int = 17
    @AppStorage("endMinute") private var endMinute: Int = 0
    @AppStorage("interval") private var interval: Int = 120 // In minutes
    
    @State private var startTime = UserDefaults.standard.getStartTime()
    @State private var endTime = UserDefaults.standard.getEndTime()
    @State private var intervalPickerIndex = UserDefaults.standard.getIntervalIndex()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private let calendar = Calendar.current
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    private let intervals = [1, 5, 15, 30, 60, 120, 180]
    
    var canSave: Bool {
        let defaultStartTime = UserDefaults.standard.getStartTime()
        let defaultEndTime = UserDefaults.standard.getEndTime()
        let defaultIntervalIndex = UserDefaults.standard.getIntervalIndex()
        return startHour != calendar.component(.hour, from: defaultStartTime) ||
            startMinute != calendar.component(.minute, from: defaultStartTime) ||
            endHour != calendar.component(.hour, from: defaultEndTime) ||
            endMinute != calendar.component(.minute, from: defaultEndTime) ||
            intervalPickerIndex != defaultIntervalIndex
    }
    
    
    private var canReset: Bool {
        let defaultStartTime = UserDefaults.standard.getStartTime()
        let defaultEndTime = UserDefaults.standard.getEndTime()
        let defaultIntervalIndex = UserDefaults.standard.getIntervalIndex()
        let currentStartTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: Date())!
        let currentEndTime = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: Date())!
        return startTime != currentStartTime ||
            endTime != currentEndTime ||
            intervalPickerIndex != defaultIntervalIndex
    }
    
    var body: some View {
        Form {
            Section(header: Text("Permission")) {
                Toggle("Enable notifications", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { newValue in
                            if newValue {
                                scheduleNotificationsForPreferredBuildings()
                            } else {
                                removeAllScheduledNotifications()
                            }
                        }
            }
            
            Section(header: Text("Notification times")) {
                DatePicker("Starting time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    .disabled(!notificationsEnabled)
                DatePicker("Ending time", selection: $endTime, displayedComponents: [.hourAndMinute])
                    .disabled(!notificationsEnabled)
            }
            
            Section(header: Text("Time interval")) {
                Picker("Select interval", selection: $intervalPickerIndex) {
                    ForEach(0..<intervals.count) { index in
                        switch intervals[index] {
                        case 1:
                            Text("1 minute")
                        case 5:
                            Text("5 minutes")
                        case 15:
                            Text("15 minutes")
                        case 30:
                            Text("30 minutes")
                        case 60:
                            Text("1 hour")
                        case 120:
                            Text("2 hours")
                        case 180:
                            Text("3 hours")
                        default:
                            Text("\(intervals[index]) minutes")
                        }
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .labelsHidden()
                .disabled(!notificationsEnabled)
            }
            
            Section {
                Button("Reset to saved preferences") {
                    resetToSavedPreferences()
                }
                .foregroundColor(.red)
                .opacity(canReset ? 1.0 : 0.5)
                .disabled(!canReset)
            }
            
        }
        .navigationTitle("Notification settings")
        .toolbar {
            ToolbarItem {
                Button(action: saveUserPreferences){
                    Text("Save")
                }
                .disabled(!notificationsEnabled || !canSave)
            }
        }
    }
    
    private func saveUserPreferences() {
        startHour = calendar.component(.hour, from: startTime)
        startMinute = calendar.component(.minute, from: startTime)
        endHour = calendar.component(.hour, from: endTime)
        endMinute = calendar.component(.minute, from: endTime)
        interval = intervals[intervalPickerIndex]
        
        UserDefaults.standard.setStartTime(startTime)
        UserDefaults.standard.setEndTime(endTime)
        UserDefaults.standard.setIntervalIndex(intervalPickerIndex)
        
        removeAllScheduledNotifications()
        scheduleNotificationsForPreferredBuildings()
    }
    
    private func scheduleNotificationsForPreferredBuildings() {
        // Fetch preferred buildings from CoreData
        let fetchRequest: NSFetchRequest<Building> = Building.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isPreferred == true")
        
        do {
            let preferredBuildings = try viewContext.fetch(fetchRequest)
            for building in preferredBuildings {
                building.scheduleNotifications()
            }
        } catch {
            print("Error fetching preferred buildings: \(error.localizedDescription)")
        }
    }
    
    private func removeAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Removed all notifications")
    }

    private func resetToSavedPreferences() {
        startTime = UserDefaults.standard.getStartTime()
        endTime = UserDefaults.standard.getEndTime()
        intervalPickerIndex = UserDefaults.standard.getIntervalIndex()
        
        startHour = calendar.component(.hour, from: startTime)
        startMinute = calendar.component(.minute, from: startTime)
        endHour = calendar.component(.hour, from: endTime)
        endMinute = calendar.component(.minute, from: endTime)
        interval = intervals[intervalPickerIndex]
    }
    
    
}


