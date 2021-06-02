//
//  MainTableViewController.swift
//  Milestone19-21
//
//  Created by Илья Москалев on 04.05.2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var notes: [Note] {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromDefaults()
        self.tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchNote))
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        cell.titleLabel?.text = notes[indexPath.row].title
        cell.dateLabel?.text = dateFormatter.string(from: notes[indexPath.row].date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.isAddPressed = false
            vc.keyFromRow = indexPath.row
            vc.note = notes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func addNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.isAddPressed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func searchNote() {
        
    }
    
    func loadFromDefaults() {
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedNotes) as? [Note] {
                notes = decodedNotes
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFromDefaults()
        tableView.reloadData()
    }
}
