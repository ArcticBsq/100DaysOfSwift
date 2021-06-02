//
//  DetailViewController.swift
//  Milestone19-21
//
//  Created by Илья Москалев on 04.05.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    var keyFromRow = 0
    var isAddPressed = false
    
    var notesDetail: [Note] {
        get {
            var array = [Note]()
            if let savedNotes = UserDefaults.standard.object(forKey: "notes") as? Data {
                if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedNotes) as? [Note] {
                    array = decodedNotes
                }
            } else {
                array = [Note]()
            }
            return array
        }
        set {
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) {
                UserDefaults.standard.set(savedData, forKey: "notes")
            }
        }
    }
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note?.body ?? "Hello, world!"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "❮ Back", style: .done, target: self, action: #selector(goBack))
        
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
        save()
    }
    
    @objc func deleteNote() {
        let ac = UIAlertController(title: nil, message: "Delete note?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.textView.text = ""
            self.goBack()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated:  true)
    }
    
    @objc func save() {
        if textView.text == "" {
            if isAddPressed {
                return
            } else {
                notesDetail.remove(at: keyFromRow)
            }
        } else {
            if isAddPressed {
//                isAddPressed = false
                let note = Note(title: String(textView.text.prefix(32)), body: textView.text, date: Date())
                notesDetail.append(note)
            } else {
                let note = notesDetail.remove(at: keyFromRow)
                note.title = String(textView.text.prefix(32))
                note.body = textView.text
                note.date = Date()
                notesDetail.insert(note, at: keyFromRow)
            }
        }
    }
}
