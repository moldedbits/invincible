//
//  DataManager.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataManager {
    
   
    
    private var databaseReference: DatabaseReference!
    
    init() {
        databaseReference = Database.database().reference()
    }
    
    func getCategories() {
        databaseReference.child("categories").observeSingleEvent(of: .value) { snapshot in
            guard let values = snapshot.value as? [String: Any] else {
                return
            }
            var categories = [Category]()
            for (key, value) in values{
                guard let category = Category(key: key, value: value) else { continue }
                categories.append(category)
            }
            print(categories)
        }
    }
    
}

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
            guard let passage = Passage.init(key: key, values: value) else { continue }
            self.passages.append(passage)
        }
    }
}


struct Passage: Codable {
    var key: String
    var displayName: Text?
    var difficulty: String?
    var passageText: Text?
    
    init?(key: String, values: Any) {
        guard let values = values as? [String: Any] else { return nil }
        self.key = key
        self.displayName = Text(values: values[Key.displayName.stringValue])
        self.difficulty = values[Key.difficulty.stringValue] as? String
        self.passageText = Text(values: values[Key.passageText.stringValue])
    }
    
    enum Key: String, CodingKey {
        case key
        case displayName = "display_name"
        case difficulty
        case passageText = "passage_text"
    }
}

struct Text: Codable {
    var spanish: String?
    var english: String?
    
    init?(values: Any?) {
        guard let values = values as? [String: Any] else { return nil }
        self.english = values[Key.english.stringValue] as? String
        self.spanish = values[Key.spanish.stringValue] as? String
    }
    
    enum Key: String, CodingKey {
        case english
        case spanish
    }
}

