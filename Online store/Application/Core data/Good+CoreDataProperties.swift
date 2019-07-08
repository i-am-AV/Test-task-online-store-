//
//  Good+CoreDataProperties.swift
//  Online store
//
//  Created by  Alexander on 05/07/2019.
//  Copyright © 2019  Alexander. All rights reserved.
//
//

import Foundation
import CoreData


extension Good {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Good> {
        return NSFetchRequest<Good>(entityName: "Good")
    }

    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var cost: String?

}
