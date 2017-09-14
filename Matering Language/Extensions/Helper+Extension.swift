//
//  Helper+Extension.swift
//  Matering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation

//Mark:- Extensions
extension UserDefaults {
    
    func getCurrentUserEmail() -> String? {
        return value(forKey: GeneralStrings.emailKey) as? String
    }
    
    func getCurrentUserAuthToken() -> String? {
        return value(forKey: GeneralStrings.authTokenKey) as? String
    }
    
    func saveCurrenstUserEmail(email: String) {
        set(email, forKey: GeneralStrings.emailKey)
        synchronize()
    }
    
    func saveCurrentUserAuthToken(authToken: String) {
        set(authToken, forKey: GeneralStrings.authTokenKey)
        synchronize()
    }
}

