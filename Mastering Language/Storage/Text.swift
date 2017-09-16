//
//  Text.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation

struct Text: Codable {
    var spanish: String?
    var english: String?
    
    init?(value: Any?) {
        guard let value = value as? [String: Any] else { return nil }
        self.english = value[Key.english.stringValue] as? String
        self.spanish = value[Key.spanish.stringValue] as? String
    }
    
    enum Key: String, CodingKey {
        case english
        case spanish
    }
}
