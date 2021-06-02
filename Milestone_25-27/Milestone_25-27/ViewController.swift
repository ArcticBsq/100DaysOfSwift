//
//  ViewController.swift
//  Milestone_25-27
//
//  Created by Илья Москалев on 14.05.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var memeView: UIImageView!
    @IBOutlet var addPictureButton: UIButton!
    var isTopLeftAddActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(shareMeme))
        
        navigationItem.rightBarButtonItems = [shareButton, refreshButton]
    }

    @IBAction func choosePicToMeme(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func choosePhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func callForTextfields() {
        let ac = UIAlertController(title: "Create meme", message: "First lane is top words\nSecond lane bottom words", preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] action in
            let topText = ac.textFields?[0].text ?? ""
            let bottomText = ac.textFields?[1].text ?? ""
            
            self?.writeAttributeTopText(top: topText, bottom: bottomText)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        memeView.image = image
        addPictureButton.isHidden = true
        
        callForTextfields()
        
        if isTopLeftAddActive {
            return
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(choosePhoto))
            isTopLeftAddActive = true
        }
    }
    
    
    @objc func refresh() {
        callForTextfields()
    }
    
    @objc func shareMeme() {
        guard let sharePicture = memeView.image?.jpegData(compressionQuality: 0.8) else { return }
        let vc = UIActivityViewController(activityItems: [sharePicture], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func writeAttributeTopText(top: String, bottom: String) {
        guard let image = memeView.image else { return }
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let memedImage = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 90),
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
        
            let topAttributedString = NSAttributedString(string: top, attributes: attrs)
            let botAttributedString = NSAttributedString(string: bottom, attributes: attrs)
            topAttributedString.draw(with: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
            botAttributedString.draw(with: CGRect(x: 0, y: image.size.height - botAttributedString.size().height, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
        }
        memeView.image = memedImage
    }
    
}

