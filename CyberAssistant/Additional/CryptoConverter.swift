//
//  CryptoConverter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 25/09/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation
import CommonCrypto

//https://stackoverflow.com/questions/25388747/sha256-in-swift

class CryptoConverter {
    class func SHA256(_ data: Data) -> Data? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
    }
    
    class func convertSHA256(string: String) -> String? {
        let targetString = string + RealmConfiguration.solt
        guard
            let data = targetString.data(using: String.Encoding.utf8),
            let shaData = SHA256(data)
            else { return nil }
        let rc = shaData.base64EncodedString(options: [])
        return rc
    }
}
