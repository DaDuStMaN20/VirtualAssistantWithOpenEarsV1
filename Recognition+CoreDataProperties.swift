//
//  Recognition+CoreDataProperties.swift
//  VirtualAssistantWithOpenEarsV1
//
//  Created by Dustin Wasserman on 8/4/16.
//  Copyright © 2016 Dustin Wasserman. All rights reserved.
//

import Foundation
import CoreData

extension Recognition {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Recognition> {
        return NSFetchRequest<Recognition>(entityName: "Recognition");
    }

    @NSManaged var hypothesis: String?
    @NSManaged var recognitionScore: Int16

}
