//
//  Passage.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation

struct Passage: Codable {
    var key: String
    var displayName: Text?
    var difficulty: String?
    var passageText: Text?
    var question = [Question]()
    var sentences = [Text]()
    
    init?(key: String, value: Any) {
        guard let value = value as? [String: Any] else { return nil }
        self.key = key
        self.displayName = Text(value: value[Key.displayName.stringValue])
        self.difficulty = value[Key.difficulty.stringValue] as? String
        self.passageText = Text(value: value[Key.passageText.stringValue])
        
        if let questions = value[Key.questions.stringValue] as? [Any] {
            for value in questions {
                guard let question = Question(value: value) else { continue }
                self.question.append(question)
            }
        }
        
        if let sentences = value[Key.sentences.stringValue] as? [Any] {
            for value in sentences {
                guard let sentence = Text(value: value) else { continue }
                self.sentences.append(sentence)
            }
        }
    }
    
    enum Key: String, CodingKey {
        case key
        case displayName = "display_name"
        case difficulty
        case passageText = "passage_text"
        case questions
        case sentences
    }
}
