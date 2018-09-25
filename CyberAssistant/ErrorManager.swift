//
//  ErrorManager.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

let errorDomain = "error.CasinoAssistant.domain"

enum ErrorCode: Int {
    case loginIsTooShort = 10000
    case passwordIsEmpty
    case passwordIsTooShort
    case repeatPasswordIsEmpty
    case repeatPasswordIsNotEqual
    
    case accountIsExist = 20000
    case accountIsNotExist
    case couldntCreateAccount
    
    case cantGetDatabase = 30000
    
    case templateIsEmpty = 40000
    
    case enternal = 50000
}

class ErrorManager {
    class func error(code: ErrorCode) -> Error {
        switch code {
            
        // 10000
        case .loginIsTooShort:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "The login is too short"])
        case .passwordIsEmpty:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "The password is empty"])
        case .passwordIsTooShort:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "The password is too short"])
        case .repeatPasswordIsEmpty:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "The repeat password is empty"])
        case .repeatPasswordIsNotEqual:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "The repeat password isn't equal to the password"])
            
        // 20000
        case .accountIsExist:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "Account with current login is existed"])
        case .accountIsNotExist:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "Account isn't existed"])
        case .couldntCreateAccount:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "Sorry. We couldn't create your account"])
            
        // 30000
        case .cantGetDatabase:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "Database isn't existed"])
            
        // 40000
        case .templateIsEmpty:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "Template can't be empty"])
            
        // 50000
        case .enternal:
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : "Sorry, something is wrong"])
        }
    }
}
