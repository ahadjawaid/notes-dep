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
    let folder: Folder
    
    @Query(sort: \Note.lastModified) private var notes: [Note]
    @Environment(\.modelContext) private var context
    
    @State private var searchText: String = ""
    
    var body: some View {
        List {
            ForEach(folder.notes) { note in
                NavigationLink(value: note) {
                    NoteListItem(note: note)
                }
            }
            .onDelete(perform: deleteNotes)
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText)
        .navigationTitle(folder.name)
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
                }
            }
        }
    }
    
    private func deleteNotes(indicies: IndexSet) {
        for index in indicies {
            context.delete(folder.notes[index])
            folder.notes.remove(at: index)
        }
    }
}
