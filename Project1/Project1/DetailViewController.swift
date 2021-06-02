//
//  DetailViewController.swift
//  Project1
//
//  Created by Илья Москалев on 21.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        // Выключаем большой title для этого vc
        navigationItem.largeTitleDisplayMode = .never
        title = "\(selectedPictureNumber) of \(totalPictures)"
        assert(selectedImage != nil, "No image in imageView")
    }
    // Скрываем и открываем кнопку назад nav controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
