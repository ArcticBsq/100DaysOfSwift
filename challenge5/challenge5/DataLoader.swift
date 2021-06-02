//
//  DataLoader.swift
//  challenge5
//
//  Created by Илья Москалев on 15.04.2021.
//

import Foundation

public class DataLoader {
    var userData = [Country]()
    
    init() {
        load()
        sort()
    }
    func load() {
        
        if let fileLocation = Bundle.main.url(forResource: "countries", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Country].self, from: data)
                
                self.userData = dataFromJson
            } catch {
                print(error)
            }
        }
    }
    
    func sort() {
        self.userData = self.userData.sorted(by: {$0.population < $1.population})
    }
}
