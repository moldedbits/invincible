//
//  Question.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation

enum QuestionType: String, Codable {
    case freeText = "free_text"
    case multipleChoice = "multiple_choice"
}

struct Question: Codable {
    var type: QuestionType?
    var text: Text?
    var options: [String]
    
    init?(value: Any?) {
        guard let value = value as? [String: Any] else { return nil }
        self.type = QuestionType(rawValue: value[Key.type.stringValue] as? String ?? "")
        self.text = Text(value: value[Key.text.stringValue])
        self.options = value[Key.options.stringValue] as? [String] ?? []
    }
    
    enum Key: String, CodingKey {
        case type
        case text = "question_text"
        case options = "options"
    }
}
