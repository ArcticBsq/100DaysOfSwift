//
//  Picture.swift
//  milestone10-12
//
//  Created by Илья Москалев on 24.03.2021.
//

import Foundation
import UIKit

class Picture: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
