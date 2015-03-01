//
//  ReferenceList.swift
//  EasyReference-IOS
//
//  Created by Marcus on 28/02/2015.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import Foundation

class ReferenceList
{
    var name: String = ""
    var references: [ReferenceItem] = []
    
    init(name: String)
    {
        self.name = name
    }
}