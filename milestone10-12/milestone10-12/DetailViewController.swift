//
//  DetailViewController.swift
//  milestone10-12
//
//  Created by Илья Москалев on 24.03.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = helpFuncs.getImageURL(for: selectedImage)
        imageView.image = UIImage(contentsOfFile: path.path)
        
    }
    
}
