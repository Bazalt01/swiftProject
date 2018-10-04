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
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("login_is_too_short", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        case .passwordIsEmpty:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("password_is_empty", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        case .passwordIsTooShort:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("password_is_too_short", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        case .repeatPasswordIsEmpty:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("repeat_password_is_empty", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        case .repeatPasswordIsNotEqual:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("passwords_arent_equal", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
            
        // 20000
        case .accountIsExist:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("login_is_existed", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        case .accountIsNotExist:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("account_isnt_existed", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        case .couldntCreateAccount:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("did_fail_create_account", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
            
        // 30000
        case .cantGetDatabase:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("database_isnt_existed", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
            
        // 40000
        case .templateIsEmpty:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("template_is_empty", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
            
        // 50000
        case .enternal:
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("something_is_wrong", comment: "")]
            return NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        }
    }
}
