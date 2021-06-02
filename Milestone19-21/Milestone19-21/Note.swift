//
//  Note.swift
//  Milestone19-21
//
//  Created by Илья Москалев on 06.05.2021.
//

import Foundation

class Note: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(body, forKey: "body")
        coder.encode(date, forKey: "date")
    }
    
    required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String ?? ""
        body = coder.decodeObject(forKey: "body") as? String ?? ""
        date = coder.decodeObject(forKey: "date") as? Date ?? Date()
        
    }
    
    var title: String
    var body: String
    var date: Date
    
    init(title: String, body: String, date: Date) {
        self.title = title
        self.body = body
        self.date = date
    }
}
