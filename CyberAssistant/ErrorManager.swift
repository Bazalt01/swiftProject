//
//  ErrorManager.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

let errorDomain = "error.CyberAssistant.domain"

enum ErrorCode: Error {
    case loginIsTooShort
    case passwordIsEmpty
    case passwordIsTooShort
    case repeatPasswordIsEmpty
    case repeatPasswordIsNotEqual
    
    case accountIsExist
    case accountIsNotExist
    case couldntCreateAccount
    
    case cantGetDatabase
    case templateIsEmpty
    
    case enternal
}

class ErrorManager {
    class func errorMessage(code: ErrorCode) -> String {
        switch code {
        case .loginIsTooShort:          return NSLocalizedString("login_is_too_short", comment: "")
        case .passwordIsEmpty:          return NSLocalizedString("password_is_empty", comment: "")
        case .passwordIsTooShort:       return NSLocalizedString("password_is_too_short", comment: "")
        case .repeatPasswordIsEmpty:    return NSLocalizedString("repeat_password_is_empty", comment: "")
        case .repeatPasswordIsNotEqual: return NSLocalizedString("passwords_arent_equal", comment: "")
            
        case .accountIsExist:           return NSLocalizedString("login_is_existed", comment: "")
        case .accountIsNotExist:        return NSLocalizedString("account_isnt_existed", comment: "")
        case .couldntCreateAccount: 	return NSLocalizedString("did_fail_create_account", comment: "")
            
        case .cantGetDatabase:          return NSLocalizedString("database_isnt_existed", comment: "")
        case .templateIsEmpty:          return NSLocalizedString("template_is_empty", comment: "")
            
        case .enternal:                 return NSLocalizedString("something_is_wrong", comment: "")
        }
    }
}
