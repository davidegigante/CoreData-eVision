//
//  Professor+CoreDataProperties.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//
//

import Foundation
import CoreData


extension Professor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Professor> {
        return NSFetchRequest<Professor>(entityName: "Professor")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var mail: String?
    @NSManaged public var lecture: Lecture?
    
    public var getName: String {
        name ?? "Unknown name"
    }
    
    public var getSurname: String {
        surname ?? "Unknown surname"
    }
    
    public var getMail: String {
        mail ?? "Unknown mail"
    }
    
}

extension Professor : Identifiable {

}
