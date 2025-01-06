//
//  FolderListItem.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI

struct FolderListItem: View {
    let folder: Folder
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "folder")
                    .foregroundStyle(.tint)
                
                Text(folder.name)
            }
            
            Spacer()
            
            Text("\(folder.notes.count)")
                .foregroundStyle(.secondary)
                .padding(.horizontal, 2)
        }
    }
}
