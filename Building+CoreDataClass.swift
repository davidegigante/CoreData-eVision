//
//  Building+CoreDataClass.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//
//

import Foundation
import CoreData

@objc(Building)
public class Building: NSManagedObject, Comparable {
    
    public static func < (lhs: Building, rhs: Building) -> Bool {
        let lhsComponents = lhs.extractComponents()
        let rhsComponents = rhs.extractComponents()

        if lhsComponents.letter == rhsComponents.letter {
            if let lhsNumber = lhsComponents.number, let rhsNumber = rhsComponents.number {
                return lhsNumber < rhsNumber
            } else {
                return rhsComponents.number != nil
            }
        } else {
            return lhsComponents.letter < rhsComponents.letter
        }
    }

    private func extractComponents() -> (letter: Character, number: Int?) {
        var letter: Character?

        let nameCharacters = getName.unicodeScalars.map(Character.init)
        let letterAndNumber = nameCharacters.reduce(into: (letter: Optional<Character>.none, number: ""), { result, character in
            if character.isLetter {
                result.letter = character
            } else if character.isNumber {
                result.number.append(character)
            }
        })

        letter = letterAndNumber.letter
        let number = Int(letterAndNumber.number)

        return (letter!, number)
    }

}
