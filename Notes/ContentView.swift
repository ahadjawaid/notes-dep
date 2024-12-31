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
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            FolderList()
                .navigationDestination(for: Folder.self) { folder in
                    NoteList(folder: folder)
                        .navigationDestination(for: Note.self) {note in
                            NoteView(note: note)
                        }
                }
        }
        .tint(.yellow)
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: [Folder.self, Note.self], inMemory: true)
}
