//
//  NoteList.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI
import SwiftData

struct NoteList: View {
    let folder: Folder
    @Binding var selectedNote: Note?
    
    @Query(sort: \Note.lastModified) private var notes: [Note]
    @Environment(\.modelContext) private var context
    
    @State private var searchText: String = ""
    
    var body: some View {
        List(selection: $selectedNote) {
            ForEach(folder.notes) { note in
                NavigationLink(value: note) {
                    Text(note.body)
                }
                .tag(note)
            }
            .onDelete(perform: deleteNotes)
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText)
        .navigationTitle(folder.name)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                
                Text("\(folder.notes.count) Note")
                    .font(.footnote)
                
                Spacer()
                
                Button("Add Note", systemImage: "square.and.pencil") {
                    let newNote = Note(folder: folder)
                    folder.notes.append(newNote)
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
