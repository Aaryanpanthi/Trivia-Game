//
//  ContentView.swift
//  Trivia Game
//
//  Created by Aaryan Panthi on 3/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var triviaManager = TriviaManager()
    
    var body: some View {
        NavigationStack {
            OptionsView()
        }
        .environment(triviaManager)
    }
}

#Preview {
    ContentView()
}
