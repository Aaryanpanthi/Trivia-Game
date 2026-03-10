//
//  TriviaManager.swift
//  Trivia Game
//
//  Created by Aaryan Panthi on 3/9/26.
//

import Foundation
import Observation

@Observable
class TriviaManager {
    
    // MARK: - Properties
    
    var questions: [TriviaQuestion] = []
    /// Cached shuffled answers per question index so order stays stable
    var shuffledAnswers: [[String]] = []
    var selectedAnswers: [Int: String] = [:]
    var isSubmitted = false
    var score = 0
    var showScore = false
    var timeRemaining = 60
    var isLoading = false
    var errorMessage: String?
    
    private var timer: Timer?
    
    // MARK: - Fetch Trivia
    
    func fetchTrivia(
        amount: Int,
        category: TriviaCategory,
        difficulty: TriviaDifficulty,
        type: TriviaType,
        timerDuration: TimerDuration
    ) async {
        isLoading = true
        errorMessage = nil
        
        // Reset state
        questions = []
        shuffledAnswers = []
        selectedAnswers = [:]
        isSubmitted = false
        score = 0
        showScore = false
        stopTimer()
        
        var components = URLComponents(string: "https://opentdb.com/api.php")!
        components.queryItems = [
            URLQueryItem(name: "amount", value: "\(amount)"),
            URLQueryItem(name: "category", value: "\(category.rawValue)"),
            URLQueryItem(name: "difficulty", value: difficulty.rawValue),
            URLQueryItem(name: "type", value: type.rawValue)
        ]
        
        guard let url = components.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
            
            if decoded.responseCode != 0 {
                errorMessage = "API Error (code \(decoded.responseCode)). Try fewer questions or a different category."
                isLoading = false
                return
            }
            
            // HTML-decode all text fields
            let cleanQuestions = decoded.results.map { q in
                TriviaQuestion(
                    category: q.category.htmlDecoded,
                    type: q.type,
                    difficulty: q.difficulty,
                    question: q.question.htmlDecoded,
                    correctAnswer: q.correctAnswer.htmlDecoded,
                    incorrectAnswers: q.incorrectAnswers.map { $0.htmlDecoded }
                )
            }
            
            questions = cleanQuestions
            // Pre-shuffle answers so they stay stable across re-renders
            shuffledAnswers = cleanQuestions.map { $0.allAnswers }
            
            // Start timer
            timeRemaining = timerDuration.rawValue
            startTimer()
            
        } catch {
            errorMessage = "Failed to load questions: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Answer Selection
    
    func selectAnswer(for questionIndex: Int, answer: String) {
        guard !isSubmitted else { return }
        selectedAnswers[questionIndex] = answer
    }
    
    // MARK: - Submit
    
    func submitAnswers() {
        guard !isSubmitted else { return }
        stopTimer()
        
        score = 0
        for (index, question) in questions.enumerated() {
            if selectedAnswers[index] == question.correctAnswer {
                score += 1
            }
        }
        isSubmitted = true
        showScore = true
    }
    
    // MARK: - Timer
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.submitAnswers()
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Helper
    
    func answerLabel(_ index: Int) -> String {
        let labels = ["A", "B", "C", "D", "E", "F"]
        return index < labels.count ? labels[index] : "\(index + 1)"
    }
    
    func isCorrect(questionIndex: Int, answer: String) -> Bool {
        return answer == questions[questionIndex].correctAnswer
    }
}
