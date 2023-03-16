//
//  Memo+CoreDataProperties.swift
//  memo
//
//  Created by Donghoon Bae on 2023/03/17.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdOrEditAtDate: Date?
    @NSManaged public var id: UUID?

}

extension Memo : Identifiable {

}
