//
//  NewFolder.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI
import SwiftData

struct NewFolder: View {
    @State private var newFolder = "New Folder";
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $newFolder)
                    .clearButton(text: $newFolder)
            }
            .navigationTitle("New Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let folder = Folder(name: newFolder)
                        dismiss()
                        context.insert(folder)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewFolder()
        .modelContainer(SampleData.shared.modelContainer)
        .tint(.yellow)
}
