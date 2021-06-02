//
//  GameData.swift
//  Project5
//
//  Created by Илья Москалев on 24.03.2021.
//

import Foundation

struct GameData: Codable {
    var currentWord: String
    var usedWords: [String]
}
