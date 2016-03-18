//
//  Pokemon.swift
//  pokemonAPI
//
//  Created by Dylan Sharkey on 3/16/16.
//  Copyright © 2016 Dylan Sharkey. All rights reserved.
//

import RealmSwift
import Foundation

class Pokemon: Object {
    dynamic var  name: String?
    dynamic var image: NSData?
    
}