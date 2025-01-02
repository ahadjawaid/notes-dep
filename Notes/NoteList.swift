//
//  NoteList.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI
import SwiftData

enum DateGroup {
    case today
    case yesterday
    case week
    case month
    case year
}

struct NoteList: View {
    @Binding var path: NavigationPath
    let folder: Folder
    
    @Environment(\.modelContext) private var context
    
    
    @State private var groupedFolderNotes: [(String, [Note])] = []
    
    @State private var searchQuery: String = ""
    @State private var searchResults: [Note] = []
    @State private var groupedByDate: Bool = true
    
    var body: some View {
        List {
            Group {
                if searchQuery.isEmpty {
                    ForEach(groupedFolderNotes, id: \.0) { (name, notes) in
                        Section(header: Text(name)) {
                            ForEach(notes) { note in
                                NavigationButton(path: $path, note: note)
                            }
                            .onDelete(perform: deleteNotes)
                        }
                        .headerProminence(.increased)
                    }
                } else {
                    ForEach(sortedNotes(searchResults)) { note in
                        NavigationButton(path: $path, note: note)
                    }
                }
            }
        }
        .tint(.primary)
        .onAppear {
            groupedFolderNotes = getNoteGroups(folder.notes).sorted {
                if $0.0 == "Today" { return true }
                if $1.0 == "Today" { return false }
                return $0.0 > $1.0
            }
        }
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

func sortedNotes(_ notes: [Note]) -> [Note] {
    notes.sorted(by: { $0.lastModified > $1.lastModified })
}

func getNoteGroups(_ notes: [Note]) -> [String: [Note]] {
    var groups: [String: [Note]] = [:]
    
    
    for note in notes {
        let dateGroup = getDateGroup(note.lastModified)
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        var dateKey: String
        if dateGroup == .today {
            dateKey = "Today"
        } else if dateGroup == .yesterday {
            dateKey = "Yesterday"
        } else if dateGroup == .week {
            dateKey = "Previous 7 Days"
        } else if dateGroup == .month {
            dateKey = "Previous 30 Days"
        } else {
            dateKey = yearFormatter.string(from: note.lastModified)
        }
        
        groups[dateKey, default: []].append(note)
    }
    
    return groups
}

func getDateGroup(_ date: Date) -> DateGroup {
    let calendar = Calendar.current
    
    if calendar.isDateInToday(date) {
        return .today
    } else if calendar.isDateInYesterday(date) {
        return .yesterday
    } else if let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()), date > sevenDaysAgo {
        return .week
    } else if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()), date > thirtyDaysAgo {
        return .month
    } else {
        return .year
    }
}

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


#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        NoteList(path: $path, folder: SampleData.shared.folder)
    }
    .tint(.yellow)
}
