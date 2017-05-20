//
//  MyRegex.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/19.
//  Copyright © 2017年 何辉. All rights reserved.
//

import Foundation

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,options: [],range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
