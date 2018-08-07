//
//  Configuration.swift
//  CasinoAssistant
//
//  Created by g.tokmakov on 16/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct Configuration {
    static let REALM_INSTANCE_URL = "casinoassistant.de1a.cloud.realm.io"
    static let AUTH_URL  = URL(string: "https://\(REALM_INSTANCE_URL)")!
    static let REALM_URL = URL(string: "realms://\(REALM_INSTANCE_URL)/ToDo")!
    static let AdminNickname = "realm-admin"
}
