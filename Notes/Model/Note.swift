//
//  Note.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import Foundation
import SwiftData

@Model
class Note {
    var dateCreated: Date
    var lastModified: Date
    var folder: Folder
    var body: String
    
    init(folder: Folder, body: String = "", dateCreated: Date = .now, lastModified: Date = .now) {
        self.folder = folder
        self.body = body
        self.dateCreated = dateCreated
        self.lastModified = lastModified
    }
    
    static let sampleData = [
        Note(folder: Folder.sampleData[0], body: "Hi I'm bob"),
        Note(folder: Folder.sampleData[0], body: "I like turtles"),
        Note(folder: Folder.sampleData[1], body: "I like to eat"),
    ]
}
