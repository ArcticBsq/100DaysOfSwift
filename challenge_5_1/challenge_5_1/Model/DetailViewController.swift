//
//  ViewController.swift
//  challenge_5_1
//
//  Created by Илья Москалев on 17.04.2021.
//

import UIKit

class DetailViewController: UIViewController {

    var country: Country?
    
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryLabel.text = country?.country_name
        capitalLabel.text = "Capital - \(country!.capital)"
        sizeLabel.text = "Size - \(String(country!.size))"
        populationLabel.text = "Poplation - \(String(country!.population))"
        currencyLabel.text = "Currency - \(country!.currency)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCountry))
    }

    @objc func shareCountry() {
        let str = "Hi, look at this information about \(String(countryLabel.text!))"
        let vc = UIActivityViewController(activityItems: [str], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem =  navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

