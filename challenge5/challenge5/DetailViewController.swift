//
//  DetailViewController.swift
//  challenge5
//
//  Created by Илья Москалев on 15.04.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countryLabel.text = country?.country_name
        capitalLabel.text = country?.capital
        sizeLabel.text = String(country!.size)
        populationLabel.text = String(country!.population)
        currencyLabel.text = country?.currency
        
    }

}
