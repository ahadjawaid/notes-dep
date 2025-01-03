//
//  SampleData.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    var folder: Folder {
        Folder.sampleData.first!
    }
    
    var note: Note {
        Note.sampleData.first!
    }
    
    init() {
        let schema = Schema([
            Folder.self,
            Note.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            
            try context.save()
        } catch {
           fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        for folder in Folder.sampleData {
            context.insert(folder)
        }
        
        for note in Note.sampleData {
            context.insert(note)
            note.folder.notes.append(note)
        }
    }
}

