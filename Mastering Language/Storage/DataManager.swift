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
