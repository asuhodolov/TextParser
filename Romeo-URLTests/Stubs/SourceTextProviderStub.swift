//
//  SourceTextProviderStub.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 25/09/2023.
//

import XCTest

class SourceTextProviderStub: TextProviding {
    let stubbedStringResourse: String
    
    init(stubbedString: String) {
        stubbedStringResourse = stubbedString
    }
    
    func loadTextResource(name: String, encoding: String.Encoding) throws -> String? {
        return stubbedStringResourse
    }
}
