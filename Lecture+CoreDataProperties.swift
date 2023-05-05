//
//  Lecture+CoreDataProperties.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//
//

import Foundation
import CoreData


extension Lecture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lecture> {
        return NSFetchRequest<Lecture>(entityName: "Lecture")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var to: Date?
    @NSManaged public var from: Date?
    @NSManaged public var professors: NSSet?
    @NSManaged public var room: Room?
    
    public var getName: String {
        name ?? "Unknown lecture name"
    }
    
    public var getType: String {
        type ?? "Unknown type"
    }
    
    public var getStartingTime: Date {
        from ?? Date()
    }
    
    public var getEndingTime: Date {
        to ?? Date()
    }
    
    public var getProfessors: [Professor] {
        let set = professors as? Set<Professor> ?? []
        
        return set.sorted {
            $0.getName > $1.getName
        }
    }

}

// MARK: Generated accessors for professors
extension Lecture {

    @objc(addProfessorsObject:)
    @NSManaged public func addToProfessors(_ value: Professor)

    @objc(removeProfessorsObject:)
    @NSManaged public func removeFromProfessors(_ value: Professor)

    @objc(addProfessors:)
    @NSManaged public func addToProfessors(_ values: NSSet)

    @objc(removeProfessors:)
    @NSManaged public func removeFromProfessors(_ values: NSSet)

}

extension Lecture : Identifiable {

}
