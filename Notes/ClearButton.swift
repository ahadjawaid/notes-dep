//
//  ClearButton.swift
//  Notes
//
//  Created by tk on 12/27/24.
//

import SwiftUI


// Source: https://softwareanders.com/swiftui-textfield-clear-button/

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button("Clear Input", systemImage: "multiply.circle.fill") {
                    text = ""
                }
                .foregroundStyle(.tertiary)
                .labelStyle(.iconOnly)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}
