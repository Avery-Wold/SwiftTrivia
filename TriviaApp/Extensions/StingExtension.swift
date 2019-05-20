//
//  StingExtension.swift
//  TriviaApp
//
//  Created by AveryW on 5/17/19.
//  Copyright © 2019 Avery. All rights reserved.
//

import Foundation

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}
