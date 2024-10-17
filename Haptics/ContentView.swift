//
//  ContentView.swift
//  Haptics
//
//  Created by Yevhen Tsyhanenko on 17/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ListView()
    }
}

struct ListView: View {

    private let sections: [[FeedbackGenerator]] = [
        [
            .impact(.light),
            .impact(.medium),
            .impact(.heavy),
            .impact(.soft),
            .impact(.rigid),
        ],
        [
            .notification(.success),
            .notification(.warning),
            .notification(.error)
        ],
        [
            .selection,
            .peek,
            .pop,
            .nope
        ],
        [
            .oldSchool
        ]
    ]
    
    var body: some View {
        NavigationStack {
            List(0..<sections.count, id: \.self) { section in
                Section {
                    ForEach(sections[section]) { item in
                        HStack {
                            Text(item.id)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            item.run()
                        }
                    }
                }
            }
            .navigationTitle("Haptics")
        }
    }
}

#Preview {
    ContentView()
}
