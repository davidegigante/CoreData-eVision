//
//  Building+CoreDataProperties.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//
//

import Foundation
import CoreData
import UserNotifications

extension Building {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Building> {
        return NSFetchRequest<Building>(entityName: "Building")
    }

    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var isPreferred: Bool
    @NSManaged public var rooms: NSSet?
    
    public var getName: String {
        name ?? "Unknown building name"
    }
    
    public var getCode: String {
        code ?? "Unknown building code"
    }
    
    public var getRooms: [Room] {
        let set = rooms as? Set<Room> ?? []
        
        return set.sorted {
            $0.getName < $1.getName
        }
    }
    
    func getRoomList() -> String {
        var str: String = ""
        let roomNames = getRooms.map { $0.getName }
        for i in 0..<roomNames.count {
            str += roomNames[i]
            if i != roomNames.count - 1 {
                str += ", "
            }
        }
        return str
    }
    
    // Custom comparison function
    func compareBuildingNames(_ a: String, _ b: String) -> ComparisonResult {
        if a.count == 1 && b.count == 1 {
            if a > b {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        } else if a.first! == b.first! {
            if a.count > b.count {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        } else {
            if a.first! > b.first! {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        }
    }
    
    func scheduleNotifications() {
        // Read the user's preferences from AppStorage
        let startHour = UserDefaults.standard.integer(forKey: "startHour")
        let startMinute = UserDefaults.standard.integer(forKey: "startMinute")
        let endHour = UserDefaults.standard.integer(forKey: "endHour")
        let endMinute = UserDefaults.standard.integer(forKey: "endMinute")
        let interval = UserDefaults.standard.integer(forKey: "interval")
        
        let calendar = Calendar.current
        let now = Date()
        
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = startHour
        components.minute = startMinute
        components.timeZone = TimeZone.current
        var startTime = calendar.date(from: components)!
        
        components.hour = endHour
        components.minute = endMinute
        components.timeZone = TimeZone.current
        let endTime = calendar.date(from: components)!
        
        // Adjust the start time for the first day if it has already passed
        if startTime < now && now < endTime {
            startTime = calendar.date(bySettingHour: calendar.component(.hour, from: now), minute: calendar.component(.minute, from: now), second: 0, of: now)!
        }
        
        // Calculate the notification times based on the user's preferences
        var notificationTimes: [Date] = []
        var nextTime = startTime
        while nextTime <= endTime {
            notificationTimes.append(nextTime)
            nextTime = calendar.date(byAdding: .minute, value: interval, to: nextTime)!
        }
        
        // Schedule notifications for the calculated times
        let center = UNUserNotificationCenter.current()
        
        for time in notificationTimes {
            let content = UNMutableNotificationContent()
            content.title = "Building \(self.getName)"
            content.body = "Check for available rooms..."
            content.sound = UNNotificationSound.default

            var triggerDate = calendar.dateComponents([.hour, .minute], from: time)
            triggerDate.timeZone = TimeZone.current
            
            // Set repeats to true
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
            let request = UNNotificationRequest(identifier: "Building-\(self.getName)-\(time)", content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Scheduled notification for building \(self.getName) at \(time)")
                }
            }
        }
    }

    func removeBuildingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests
                .filter { $0.identifier.hasPrefix("Building-\(self.getName)-") }
                .map { $0.identifier }
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            print("Removed notifications for building \(self.getName)")
        }
    }

}

// MARK: Generated accessors for rooms
extension Building {

    @objc(addRoomsObject:)
    @NSManaged public func addToRooms(_ value: Room)

    @objc(removeRoomsObject:)
    @NSManaged public func removeFromRooms(_ value: Room)

    @objc(addRooms:)
    @NSManaged public func addToRooms(_ values: NSSet)

    @objc(removeRooms:)
    @NSManaged public func removeFromRooms(_ values: NSSet)

}

extension Building : Identifiable {

}
