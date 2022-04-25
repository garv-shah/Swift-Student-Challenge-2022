//
//  File.swift
//  Orbit
//
//  Created by Garv Shah on 22/4/2022.
//

import Foundation
import SwiftUI
import Combine

struct UISignedInput: View {
    let label: String?
    var binding: Binding<String>
    @State var inputText: String

    var body: some View {
        VStack {
            if label != nil { Text(label!) }

            TextField(inputText, text: binding)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .onReceive(Just(inputText)) { newValue in
                    let filtered = newValue.filter { "0123456789.-".contains($0) }
                    if filtered != newValue {
                        self.inputText = filtered
                    }
            }
        }
    }
}

struct UIUnsignedInput: View {
    let label: String?
    var binding: Binding<String>
    @State var inputText: String

    var body: some View {
        VStack {
            if label != nil { Text(label!) }

            TextField(inputText, text: binding)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .onReceive(Just(inputText)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.inputText = filtered
                    }
            }
        }
    }
}

struct UIIntInput: View {
    let label: String?
    var binding: Binding<String>
    @State var inputText: String

    var body: some View {
        VStack {
            if label != nil { Text(label!) }

            TextField(inputText, text: binding)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .onReceive(Just(inputText)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.inputText = filtered
                    }
            }
        }
    }
}
