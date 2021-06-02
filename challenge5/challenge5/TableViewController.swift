//
//  TableViewController.swift
//  challenge5
//
//  Created by Илья Москалев on 15.04.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    let data = DataLoader().userData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = data[indexPath.row].country_name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController {
            vc.country = data[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}
