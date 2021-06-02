//
//  DetailViewController.swift
//  Milestone Project1-3
//
//  Created by Илья Москалев on 25.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var selectedImage: UIImageView!
    var imageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = imageName {
            selectedImage.image = UIImage(named: imageToLoad)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    @objc func shareTapped(){
        guard let image = selectedImage.image?.jpegData(compressionQuality: 0.8) else {
            print("No photo")
            return
        }
        let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
