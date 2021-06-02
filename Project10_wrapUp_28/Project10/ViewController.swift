//
//  ViewController.swift
//  Project10
//
//  Created by Илья Москалев on 15.03.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell else {
            fatalError("Unable to dequeue CollectionViewCell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camere", style: .default) { _ in
            self.openCamera(picker)
        })
        ac.addAction(UIAlertAction(title: "Photo library", style: .default) { _ in
            self.openLibrary(picker)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(ac, animated: true)
        
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func openCamera(_ imagePicker: UIImagePickerController) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    func openLibrary(_ imagePicker: UIImagePickerController) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rename person", style: .default) { [weak self] action in
            self?.renamePersonTapped(person)
        })
        ac.addAction(UIAlertAction(title: "Delete person", style: .destructive) { [weak self] action in
            self?.deletePersonTapped(person, index)
        })

        present(ac, animated: true)
    }
    
    func renamePersonTapped(_ person: Person) {
        let ac = UIAlertController(title: "Rename person", message: "Type name here", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func deletePersonTapped(_ person: Person, _ index: Int) {
        let ac = UIAlertController(title: "Delete person?", message: "Do you really want to delete thet person?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.people.remove(at: index)
            
            self?.collectionView.reloadData()
        })
        present(ac, animated: true)
    }
}



