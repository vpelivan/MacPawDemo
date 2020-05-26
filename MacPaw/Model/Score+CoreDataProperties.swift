//
//  Score+CoreDataProperties.swift
//  MacPaw
//
//  Created by Victor Pelivan on 24.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var count: Int16
    @NSManaged public var questionsCount: Int16
    @NSManaged public var date: Date?

}
