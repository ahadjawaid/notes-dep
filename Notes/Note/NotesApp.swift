//
//  NotesApp.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Folder.self, Note.self])
    }
}
