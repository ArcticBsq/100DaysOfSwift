//
//  helpFuncs.swift
//  milestone10-12
//
//  Created by Илья Москалев on 25.03.2021.
//

import Foundation

class helpFuncs {
   static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   static func getImageURL(for imageName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(imageName)
    }
}
