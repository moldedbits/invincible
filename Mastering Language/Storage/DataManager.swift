//
//  DataManager.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
import PromiseKit

enum MLError: Error {
    case decodingFailed(reason: String)
    case unauthorize(reason: String)
    case unknown(reason: String)
}
enum DatabaseKey:String {
    case categories
    case passages
}
class DataManager {
    private var databaseReference: DatabaseReference!
    
    init() {
        databaseReference = Database.database().reference()
    }
    
    func getCategories() -> Promise<[Category]> {
        return Promise { fulfill, reject in
            databaseReference.child("categories").observeSingleEvent(of: .value) { snapshot in
                guard let values = snapshot.value as? [String: Any] else {
                    reject(MLError.decodingFailed(reason: "Decoding failed"))
                    return
                }
                var categories = [Category]()
                for (key, value) in values {
                    guard let category = Category(key: key, value: value) else { continue }
                    categories.append(category)
                }
                fulfill(categories)
            }
        }
    }
    
    func getPassages() -> Promise<[Passage]> {
        return Promise { fulfill, reject in
            databaseReference.child("passages").observeSingleEvent(of: .value) { snapshot in
                guard let values = snapshot.value as? [String: Any] else {
                    reject(MLError.decodingFailed(reason: "Decoding failed"))
                    return
                }
                var passages = [Passage]()
                for (key, value) in values {
                    guard let passage = Passage(key: key, value: value) else { continue }
                    passages.append(passage)
                }
                fulfill(passages)
            }
        }
    }
    
    func getPassage(key: String) -> Promise<Passage> {
        return Promise { fulfill, reject in
            databaseReference.child(DatabaseKey.passages.rawValue).child(key).observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value,
                    let passage = Passage(key: key, value: value)
                    else {
                        reject(MLError.decodingFailed(reason: "Decoding failed"))
                        return
                }
                
                fulfill(passage)
            }
        }
    }
    
    func saveAnswers(answer: [[String: Any]], passage: Passage) -> Promise<Void> {
        return Promise { fulfill, reject in
            guard let uid = Auth.auth().currentUser?.uid else {
                reject(MLError.unauthorize(reason: "User now available"))
                return
            }
            
            databaseReference.child("users").child(uid).setValue([passage.key: answer]) { error, ref in
                guard let error = error else {
                    fulfill(())
                    return
                }
                reject(error)
            }
        }
    }
    
    func getAnswers(passage: Passage) -> Promise<[Answer]> {
        return Promise { fulfill, reject in
            guard let uid = Auth.auth().currentUser?.uid else {
                reject(MLError.unauthorize(reason: "User now available"))
                return
            }
            
            databaseReference.child("users").child(uid).child(passage.key).observeSingleEvent(of: .value) { snapshot in
                guard let values = snapshot.value as? [Any]
                    else {
                        reject(MLError.decodingFailed(reason: "Decoding failed"))
                        return
                    }
                
                var answers = [Answer]()
                for value in values {
                    guard let answer = Answer(value: value) else { continue }
                    answers.append(answer)
                }
                
                fulfill(answers)
                return
            }
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
            guard let passage = Passage.init(key: key, value: value) else { continue }
            self.passages.append(passage)
        }
    }
}


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

