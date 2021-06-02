//
//  TableViewController.swift
//  Project4_Wrap
//
//  Created by Илья Москалев on 02.03.2021.
//

import UIKit

class TableViewController: UITableViewController {

    let sites = ["hackingwithswift.com", "apple.com", "vk.com", "github.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = sites[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? ViewController {
            vc.sites = sites
            vc.website = sites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
