//
//  TriviaQuestion.swift
//  Trivia Game
//
//  Created by Aaryan Panthi on 3/9/26.
//

import Foundation

// MARK: - API Response

struct TriviaResponse: Codable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

// MARK: - Trivia Question

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    /// All answers shuffled (cached per instance via lazy-like approach)
    var allAnswers: [String] {
        (incorrectAnswers + [correctAnswer]).shuffled()
    }
}

// MARK: - Category

enum TriviaCategory: Int, CaseIterable, Identifiable {
    case generalKnowledge = 9
    case books = 10
    case film = 11
    case music = 12
    case musicalsTheatres = 13
    case television = 14
    case videoGames = 15
    case boardGames = 16
    case scienceNature = 17
    case computers = 18
    case mathematics = 19
    case mythology = 20
    case sports = 21
    case geography = 22
    case history = 23
    case politics = 24
    case art = 25
    case celebrities = 26
    case animals = 27
    case vehicles = 28
    case comics = 29
    case gadgets = 30
    case anime = 31
    case cartoons = 32
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
        case .generalKnowledge: return "General Knowledge"
        case .books: return "Books"
        case .film: return "Film"
        case .music: return "Music"
        case .musicalsTheatres: return "Musicals & Theatres"
        case .television: return "Television"
        case .videoGames: return "Video Games"
        case .boardGames: return "Board Games"
        case .scienceNature: return "Science & Nature"
        case .computers: return "Computers"
        case .mathematics: return "Mathematics"
        case .mythology: return "Mythology"
        case .sports: return "Sports"
        case .geography: return "Geography"
        case .history: return "History"
        case .politics: return "Politics"
        case .art: return "Art"
        case .celebrities: return "Celebrities"
        case .animals: return "Animals"
        case .vehicles: return "Vehicles"
        case .comics: return "Comics"
        case .gadgets: return "Gadgets"
        case .anime: return "Anime & Manga"
        case .cartoons: return "Cartoons & Animations"
        }
    }
}

// MARK: - Difficulty

enum TriviaDifficulty: String, CaseIterable, Identifiable {
    case easy, medium, hard
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}

// MARK: - Question Type

enum TriviaType: String, CaseIterable, Identifiable {
    case multiple
    case boolean
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .multiple: return "Multiple Choice"
        case .boolean: return "True / False"
        }
    }
}

// MARK: - Timer Duration

enum TimerDuration: Int, CaseIterable, Identifiable {
    case thirty = 30
    case sixty = 60
    case ninety = 90
    case onetwenty = 120
    var id: Int { rawValue }
    var displayName: String { "\(rawValue) seconds" }
}

// MARK: - HTML Entity Decoding

extension String {
    var htmlDecoded: String {
        var result = self
        let entities: [String: String] = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&#039;": "'",
            "&apos;": "'",
            "&ndash;": "–",
            "&mdash;": "—",
            "&laquo;": "«",
            "&raquo;": "»",
            "&ldquo;": "\u{201C}",
            "&rdquo;": "\u{201D}",
            "&lsquo;": "\u{2018}",
            "&rsquo;": "\u{2019}",
            "&hellip;": "…",
            "&eacute;": "é",
            "&ouml;": "ö",
            "&uuml;": "ü",
            "&pi;": "π"
        ]
        for (entity, char) in entities {
            result = result.replacingOccurrences(of: entity, with: char)
        }
        return result
    }
}
