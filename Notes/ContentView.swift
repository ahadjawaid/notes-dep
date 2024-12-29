//
//  ContentView.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI
import SwiftData

func getCurrentDevice() -> String {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return "iPhone"
    case .pad:
        return "iPad"
    case .mac:
        return "Mac"
    default:
        return "Device"
    }
}


struct ContentView: View {
    @Query(sort: \Folder.name) private var folders: [Folder]
    @Environment(\.modelContext) private var context
    
    @State var selectedFolder: Folder?
    @State var selectedNote: Note?
    
    var body: some View {
        NavigationSplitView {
            FolderList(selectedFolder: $selectedFolder)
        } content: {
            if let folder = selectedFolder {
                NoteList(folder: folder, selectedNote: $selectedNote)
            } else {
                Text("Please select a folder")
            }
        } detail: {
            if let note = selectedNote {
                NoteView(note: note)
            } else {
                Text("Please selecte a note")
            }
        }
        .tint(.yellow)
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: [Folder.self, Note.self], inMemory: true)
}
