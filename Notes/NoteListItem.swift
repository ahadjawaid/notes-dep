//
//  NoteListItem.swift
//  Notes
//
//  Created by tk on 12/31/24.
//

import SwiftUI

struct NoteListItem: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .bold()
            
            Text("\(getDay())  \(note.additionalText)")
                .foregroundStyle(.secondary)
        }
    }
    
    private func getDay() -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        if calendar.isDateInToday(note.lastModified) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: note.lastModified)
        } else if calendar.isDate(note.lastModified, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: note.lastModified)
        } else {
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: note.lastModified)
        }
        
    }
}

#Preview {
    List {
        NoteListItem(note: SampleData.shared.note)
    }
}
