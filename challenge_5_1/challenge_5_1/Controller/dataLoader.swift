//
//  jsonController.swift
//  challenge_5_1
//
//  Created by Илья Москалев on 17.04.2021.
//

import Foundation

class DataLoader {
    var userData = [Country]()
    
    init() {
        load()
        sort()
    }
    
    func load() {
        if let path = Bundle.main.url(forResource: "countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Country].self, from: data)
                
                self.userData = dataFromJson
                
            }   catch {
                print(error)
            }
        }
    }
    
    func sort() {
        self.userData = self.userData.sorted(by: {$0.population > $1.population})
    }
}
