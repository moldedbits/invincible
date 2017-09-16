//
//  Category.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation

struct Category: Codable {
    var key: String
    var passages = [Passage]()
    
    enum Key: String, CodingKey {
        case key
        case passage
    }
    
    init?(key: String, value: Any?) {
        guard let value = value as? [String: Any],
            let passages = value["passages"] as? [String: Any]
            else { return nil }
        self.key = key
        for (key, value) in passages {
            guard let passage = Passage.init(key: key, value: value) else { continue }
            self.passages.append(passage)
        }
    }
}
