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
        
        self.folder.notes.append(self)
    }
    
    var title: String {
        let lines = self.body.split(separator: "\n")
        return lines.count > 0 ? String(lines[0]) : "New Note"
    }
    
    var additionalText: String {
        let lines = self.body.split(separator: "\n")
        return lines.count > 1 ? String(lines[1]) : "No additional text"
    }
    
    
    static let sampleData = [
        Note(folder: Folder.sampleData[0], body: "Hi I'm bob"),
        Note(folder: Folder.sampleData[0], body: "I like turtles", lastModified: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        Note(folder: Folder.sampleData[0], body: "I don't like turtles", lastModified: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
        Note(folder: Folder.sampleData[0], body: "I like don't to eat", lastModified: Calendar.current.date(byAdding: .day, value: -15, to: Date())!),
        Note(folder: Folder.sampleData[0], body: "I hate yummy food", lastModified: Calendar.current.date(byAdding: .year, value: -1, to: Date())!),
        Note(folder: Folder.sampleData[0], body: "This food is yummy", lastModified: Calendar.current.date(byAdding: .year, value: -2, to: Date())!),
        Note(folder: Folder.sampleData[0], body: "I like water", lastModified: Calendar.current.date(byAdding: .year, value: -3, to: Date())!),
        Note(folder: Folder.sampleData[1], body: "I like to eat"),
    ]
}
