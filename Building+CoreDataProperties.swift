//
//  Building+CoreDataProperties.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//
//

import Foundation
import CoreData


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
