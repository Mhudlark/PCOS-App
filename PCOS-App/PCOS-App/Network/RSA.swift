//
//  RSA.swift
//  PCOS-App
//
//  Created by Hugh Henry on 22/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import Foundation

class RSA {
    
    static let rsaPublicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAktfiT+cnZPj0mm0sxJ13ENlFg7+qQpPSp5mCgFSJpV9Onvs3FLVFlPR5v9iZYOdPq0IgPk8OKeuIsKuLE6KwvRfup3vhtkTI+rrUL6dvTalFldtN2bC4UEiiFifVzaVYhzYK39h8fwD/5JKrr7FsI7izkVELFX7wcCELHcSbx6lNYD102JSgdbY7lqn+PuFi7AUxalr8YcjONWOqztRoZg5BcrxY9OULLHpxxxxUZotIIthXYuIEmvmt37bPUor4m/iAOLiv1o2BVWUw+kNmEoC6L1tPOWfjkFsNHpsSZb2NtvVr9q48XqvcxumyB8tIQOEvMyUYGWl4BeUlyH/ChwIDAQAB"
    
    static func encrypt(string: String, publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }

        let keyString = publicKey.replacingOccurrences(of: rsaPublicKey, with: "").replacingOccurrences(of: rsaPublicKey, with: "")
        guard let data = Data(base64Encoded: keyString) else { return nil }

        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : kCFBooleanTrue] as CFDictionary
        }

        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            print(error.debugDescription)
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
    }

    static func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)

        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)

        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}
