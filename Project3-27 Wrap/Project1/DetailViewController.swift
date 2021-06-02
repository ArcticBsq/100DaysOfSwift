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
        title = "Picture \(selectedPictureNumber) of \(totalPictures)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
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
    
    @objc func shareTapped() {
        guard let image = imageView.image else { return }
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let img = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            let string = "Project 27 wrap up 3"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
        }
        guard let sharePicture = img.jpegData(compressionQuality: 0.8) else { return }
        let vc = UIActivityViewController(activityItems: [sharePicture, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
            
    }

}
