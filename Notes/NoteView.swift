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
    @Environment(\.dismiss) private var dismiss
    
    @State var text: String = "Type here..."
    @State private var showDate: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            if showDate {
                Text("\(note.lastModified)")
            }
            
            TextEditor(text: $text)
                .onAppear {
                    text = note.body
                }
                .onChange(of: text) {
                    note.body = text
                }
                .focused($isFocused)
                .border(isFocused ? .red : .clear)
        }
        .padding()
        .toolbar() {
            if isFocused {
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NoteView(note: SampleData.shared.note)
            .modelContainer(for: Note.self, inMemory: true)
    }
}
