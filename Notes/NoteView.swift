//
//  NoteView.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI
import SwiftData

struct NoteView: View {
    let note: Note
    
    @Environment(\.modelContext) private var context
    
    @State var text: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Text("\(getFormattedDate(date: note.lastModified))")
                .foregroundStyle(.secondary)
            
            TextEditor(text: $text)
                .onAppear {
                    text = note.body
                }
                .onChange(of: text) {
                    note.body = text
                }
                .focused($isFocused)
        }
        .padding()
        .toolbar {
            ToolbarItem {
                Button("Share", systemImage: "square.and.arrow.up") {}
                    .disabled(text.isEmpty)
            }
            
            ToolbarItemGroup() {
                Menu {
                    if !text.isEmpty {
                        Button("Pin", systemImage: "pin.fill") {}
                        Button("Find in Note", systemImage: "magnifyingglass") {}
                        Button("Move Note", systemImage: "folder") {}
                        Button("Recent Notes", systemImage: "clock") {}
                    }

                    Button("Lines & Grids", systemImage: "rectangle.split.3x3") {}

                    if !text.isEmpty {
                        Button("Use Light Background", systemImage: "circle.righthalf.filled") {}
                        Button("Delete", systemImage: "trash", role: .destructive) {}
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis.circle")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if isFocused {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
        .onDisappear {
            if note.body.isEmpty {
                note.folder.notes.removeAll { $0 == note }
                context.delete(note)
            }
        }
    }
    
    private func getFormattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        NoteView(note: SampleData.shared.note)
            .modelContainer(for: Note.self, inMemory: true)
            .tint(.yellow)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        NoteView(note: SampleData.shared.note)
            .modelContainer(for: Note.self, inMemory: true)
    }
    .preferredColorScheme(.dark)
    .tint(.yellow)
}
