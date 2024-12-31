//
//  FolderList.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI
import SwiftData

struct FolderList: View {
    @Binding var selectedFolder: Folder?
    
    @Query(sort: \Folder.name) private var folders: [Folder]
    @Environment(\.modelContext) private var context
    
    @State private var searchQuery = ""
    @State private var searchResults: [Folder] = []
    
    @State private var displayNewFolderForm = false
    
    var body: some View {
        List(selection: $selectedFolder) {
            ForEach((searchQuery.isEmpty ? folders : searchResults).reversed()) { folder in
                NavigationLink(value: folder) {
                    FolderListItem(folder: folder)
                }
                .tag(folder)
            }
            .onDelete(perform: deleteFolder)
        }
        .searchable(text: $searchQuery)
        .textInputAutocapitalization(.never)
        .onChange(of: searchQuery) {
            filterSearchResults(query: searchQuery)
        }
        .navigationTitle("Folders")
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button("Add Folder", systemImage: "folder.badge.plus") {
                    displayNewFolderForm = true
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button("Add Note", systemImage: "square.and.pencil") {
                    
                }
            }
        }
        .sheet(isPresented: $displayNewFolderForm) {
            NewFolder()
        }
    }
    
    private func filterSearchResults(query: String) {
        searchResults = folders.filter { folder in
            folder.name
                  .lowercased()
                  .contains(query.lowercased())
        }
        
    }
    
    private func deleteFolder(indicies: IndexSet) {
        for index in indicies {
            context.delete(folders[index])
        }
    }
}
