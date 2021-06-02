//
//  DetailViewController.swift
//  Milestone19-21
//
//  Created by Илья Москалев on 04.05.2021.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "Hello, world!"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    

    @objc func save() {
        
    }

    
}
