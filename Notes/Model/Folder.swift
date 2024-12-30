//
//  Folder.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import Foundation
import SwiftData

@Model
class Folder {
    var name: String
    var dateCreated: Date
    var notes = [Note]()
    var folders = [Folder]()
    
    init(name: String, dateCreate: Date = .now) {
        self.name = name
        self.dateCreated = dateCreate
    }
    
    static let sampleData = [
        Folder(name: "Personal"),
        Folder(name: "Work"),
        Folder(name: "Family"),
    ]
}
