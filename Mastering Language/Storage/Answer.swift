//
//  Answer.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation

struct Answer: Codable {
    var question: Text?
    var answer: String?
    
    init?(value: Any?) {
        guard let value = value as? [String: Any] else { return nil }
        self.question = Text(value: value[Key.question.stringValue])
        self.answer = value[Key.answer.stringValue] as? String
    }
    
    enum Key: String, CodingKey {
        case question
        case answer
    }
}
