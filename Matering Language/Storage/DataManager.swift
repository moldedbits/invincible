//
//  DataManager.swift
//  Matering Language
//
//  Created by Amit Kumar Swami on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataManager {
    
    private enum DatabaseStructure: String {
        case categories
        case passages
        
        enum Passage: String {
            case difficulty
            case displayName = "display_name"
            case passageText = "passage_text"
            case questions
            case sentences
            
            enum PassageText: String {
                case english
                case spanish
            }
        }
        
        
    }
    
    private var databaseReference: DatabaseReference!
    
    init() {
        databaseReference = Database.database().reference()
    }
    
    func getCategories() {
        databaseReference.child("categories")
    }
    
}
