//
//  NavigationButton.swift
//  Notes
//
//  Created by tk on 1/1/25.
//

import SwiftUI

struct NavigationButton: View {
    @Binding var path: NavigationPath
    let note: Note
    
    var body: some View {
        Button {
            path.append(note)
        } label: {
            NoteListItem(note: note)
        }
    }
}
