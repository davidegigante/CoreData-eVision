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
