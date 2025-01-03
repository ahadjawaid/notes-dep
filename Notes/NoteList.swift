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

struct GroupByDatePicker: View {
    @Binding var groupedByDate: Bool
    
    var body: some View {
        Picker(selection: $groupedByDate) {
            Text("On").tag(true)
            Text("Off").tag(false)
        } label: {
            Text("Group By Date")
            Text(groupedByDate ? "On" : "Off")
        } currentValueLabel: {
            Image(systemName: "calendar")
        }
    }
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
                    if groupedByDate {
                        ForEach(groupedFolderNotes, id: \.0) { (name, notes) in
                            Section(header: Text(name)) {
                                ForEach(sortedNotes(notes)) { note in
                                    NavigationButton(path: $path, note: note)
                                }
                                .onDelete(perform: deleteNotes)
                            }
                            .headerProminence(.increased)
                        }
                    } else {
                        ForEach(sortedNotes(folder.notes)) { note in
                            NavigationButton(path: $path, note: note)
                        }
                        .onDelete(perform: deleteNotes)
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
                Button("View as Gallery", systemImage: "square.grid.2x2") {}
                Button("Add Folder", systemImage: "folder.badge.plus") {}
                Button("Rename", systemImage: "pencil") {}
                Button("Select Notes", systemImage: "check.circle") {}
                Button("Sort By", systemImage: "arrow.up.arrow.down") {}
                GroupByDatePicker(groupedByDate: $groupedByDate)
                Button("View Attachments", systemImage: "paperclip") {}
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

private func sortedNotes(_ notes: [Note]) -> [Note] {
    notes.sorted(by: { $0.lastModified > $1.lastModified })
}

private func getNoteGroups(_ notes: [Note]) -> [String: [Note]] {
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

private func getDateGroup(_ date: Date) -> DateGroup {
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


#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        NoteList(path: $path, folder: SampleData.shared.folder)
    }
    .tint(.yellow)
}
