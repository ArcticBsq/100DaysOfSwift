//
//  TableViewController.swift
//  Homeworl milestone 1-3
//
//  Created by Илья Москалев on 25.02.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("3x.png") {
                flags.append(item)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return flags.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = flags[indexPath.row].uppercased().replacingOccurrences(of: "@3X.PNG", with: "")
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
