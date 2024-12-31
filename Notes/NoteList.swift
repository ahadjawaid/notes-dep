//
//  NoteList.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI
import SwiftData

struct SecondaryToolbarButton: Identifiable {
    let id = UUID()
    
    let text: String
    let systemImage: String
    let action: @MainActor () -> Void
}

let secondaryToolbarButtons: [SecondaryToolbarButton] = [
    SecondaryToolbarButton(text: "View as Gallery", systemImage: "square.grid.2x2", action: {
        
    }),
    SecondaryToolbarButton(text: "Add Folder", systemImage: "folder.badge.plus", action: {
        
    }),
    SecondaryToolbarButton(text: "Move This Folder", systemImage: "folder", action: {
        
    }),
    SecondaryToolbarButton(text: "Rename", systemImage: "pencil", action: {
        
    }),
    SecondaryToolbarButton(text: "Select Notes", systemImage: "check.circle", action: {
        
    }),
    SecondaryToolbarButton(text: "Sort By", systemImage: "arrow.up.arrow.down", action: {
        
    }),
    SecondaryToolbarButton(text: "Group By Date", systemImage: "calendar", action: {
        
    }),
    SecondaryToolbarButton(text: "View Attachments", systemImage: "paperclip", action: {
        
    }),
]

struct NoteList: View {
    @Binding var path: NavigationPath
    let folder: Folder
    
    @Environment(\.modelContext) private var context
    
    @State private var searchQuery: String = ""
    @State private var searchResults: [Note] = []
    @State private var groupedByDate: Bool = true
    
    var body: some View {
        List {
            ForEach(searchQuery.isEmpty ? folder.notes : searchResults) { note in
                Button {
                    path.append(note)
                } label: {
                    NoteListItem(note: note)
                }
            }
            .onDelete(perform: deleteNotes)
        }
        .tint(.primary)
        .navigationTitle(folder.name)
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery) {
            filterSearchResults(query: searchQuery)
        }
        .toolbar {
            ToolbarItemGroup(placement: .secondaryAction) {
                ForEach(secondaryToolbarButtons) { button in
                    Button(button.text, systemImage: button.systemImage, action: button.action)
                }
                
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                
                Text(folder.notes.count > 0 ? "\(folder.notes.count) Note" : "No Notes")
                    .font(.footnote)
                
                Spacer()
                
                Button("Add Note", systemImage: "square.and.pencil") {
                    let newNote = Note(folder: folder)
                    context.insert(newNote)
                    path.append(newNote)
                }
            }
        }
    }
    
    private func filterSearchResults(query: String) {
        searchResults = folder.notes.filter { note in
            note.title.lowercased().contains(query.lowercased()) ||
            note.additionalText.lowercased().contains(query.lowercased())
        }
    }
    
    private func deleteNotes(indicies: IndexSet) {
        for index in indicies {
            context.delete(folder.notes[index])
            folder.notes.remove(at: index)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        NoteList(path: $path, folder: SampleData.shared.folder)
    }
    .tint(.yellow)
}
