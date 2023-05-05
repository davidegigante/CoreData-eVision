//
//  Room+CoreDataProperties.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var lectures: NSSet?
    @NSManaged public var building: Building?
    
    public var getName: String {
        name ?? "Unknown room name"
    }
    
    public var getId: String {
        id ?? "Unknown id"
    }
    
    public var getLectures: [Lecture] {
        let set = lectures as? Set<Lecture> ?? []
        
        return set.sorted {
            $0.getStartingTime < $1.getStartingTime
        }
    }

}

// MARK: Generated accessors for lectures
extension Room {

    @objc(addLecturesObject:)
    @NSManaged public func addToLectures(_ value: Lecture)

    @objc(removeLecturesObject:)
    @NSManaged public func removeFromLectures(_ value: Lecture)

    @objc(addLectures:)
    @NSManaged public func addToLectures(_ values: NSSet)

    @objc(removeLectures:)
    @NSManaged public func removeFromLectures(_ values: NSSet)

}

extension Room : Identifiable {

}
