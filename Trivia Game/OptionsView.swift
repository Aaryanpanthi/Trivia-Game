//
//  OptionsView.swift
//  Trivia Game
//
//  Created by Aaryan Panthi on 3/9/26.
//

import SwiftUI

struct OptionsView: View {
    @Environment(TriviaManager.self) var triviaManager
    
    @State private var numberOfQuestions: String = "5"
    @State private var selectedCategory: TriviaCategory = .sports
    @State private var selectedDifficulty: TriviaDifficulty = .easy
    @State private var selectedType: TriviaType = .multiple
    @State private var selectedTimer: TimerDuration = .sixty
    @State private var navigateToTrivia = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Blue header
            ZStack {
                Color.blue
                    .ignoresSafeArea(edges: .top)
                
                Text("Trivia Game")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 16)
            }
            .frame(height: 100)
            
            // Options form
            Form {
                // Number of questions
                Section {
                    TextField("Number of Questions", text: $numberOfQuestions)
                        .keyboardType(.numberPad)
                }
                
                // Category
                Section {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(TriviaCategory.allCases) { category in
                            Text(category.name).tag(category)
                        }
                    }
                }
                
                // Difficulty
                Section {
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(TriviaDifficulty.allCases) { diff in
                            Text(diff.displayName).tag(diff)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Type
                Section {
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(TriviaType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }
                
                // Timer duration
                Section {
                    Picker("Timer Duration", selection: $selectedTimer) {
                        ForEach(TimerDuration.allCases) { duration in
                            Text(duration.displayName).tag(duration)
                        }
                    }
                }
            }
            
            // Start button
            Button(action: {
                let amount = Int(numberOfQuestions) ?? 5
                Task {
                    await triviaManager.fetchTrivia(
                        amount: amount,
                        category: selectedCategory,
                        difficulty: selectedDifficulty,
                        type: selectedType,
                        timerDuration: selectedTimer
                    )
                    navigateToTrivia = true
                }
            }) {
                Text("Start Trivia")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .background(Color.blue)
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToTrivia) {
            TriviaView()
        }
    }
}

#Preview {
    NavigationStack {
        OptionsView()
            .environment(TriviaManager())
    }
}
