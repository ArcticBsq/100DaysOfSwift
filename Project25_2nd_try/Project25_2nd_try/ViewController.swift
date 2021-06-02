//
//  ViewController.swift
//  Project25_2nd_try
//
//  Created by Илья Москалев on 12.05.2021.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, MCBrowserViewControllerDelegate, UINavigationControllerDelegate, MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            // MARK: Wrap up 1
            let ac = UIAlertController(title: nil, message: "\(peerID.displayName) has disconnected.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .cancel))
            
            print("Not connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.pictures.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let ac = UIAlertController(title: "Message from \(peerID.displayName)", message: String(decoding: data, as: UTF8.self), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    

    var pictures = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Selfie Share"
        
//        let connectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
//        let messageButton = UIBarButtonItem(title: "New message", style: .done, target: self, action: #selector(sendMessage))
//        let allPeersButton = UIBarButtonItem(title: "Peers", style: .done, target: self, action: #selector(showConnections))
//        let importPictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
//
//        navigationItem.leftBarButtonItems = [connectionButton, allPeersButton]
//        navigationItem.rightBarButtonItems = [messageButton, importPictureButton]
        
        let addConenectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let sendMessageButton = UIBarButtonItem(title: "Send message", style: .plain, target: self, action: #selector(sendMessage))
        let importPictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let connectionListButton = UIBarButtonItem(title: "Connections", style: .plain, target: self, action: #selector(showConnections))
                
        navigationItem.leftBarButtonItems = [addConenectionButton, sendMessageButton]
        navigationItem.rightBarButtonItems = [connectionListButton, importPictureButton]
        
        peerId = MCPeerID(displayName: UIDevice.current.name)
        
        mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = pictures[indexPath.row]
        }
        return cell
    }
    // Метод передачи фото из галереи
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // Метод работы с imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        pictures.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    // Метод в которомы мы вызываем alertController в котором выбираем хостить или подключаться
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    // MARK: Начинается работа с MultipeerConnectivity
    var peerId = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    // Метод отвечающий за начало хостинга
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    // Метод позволяет подключаться к существующим хостам
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    // MARK: Wrap up 2
    @objc func sendMessage() {
        let ac = UIAlertController(title: "Type your message below", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak ac] action in
            
            guard let mcSession = self?.mcSession else { return }
            if mcSession.connectedPeers.count > 0 {
                if let textData = ac?.textFields?[0].text {
                    do {
                        try mcSession.send(Data(textData.utf8), toPeers: mcSession.connectedPeers, with: .reliable)
                    } catch {
                        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
            
        }))
    }
    // MARK: Wrap up 3
    @objc func showConnections() {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            var message = ""
            for i in 0..<mcSession.connectedPeers.count {
                message += "\(i + 1). \(mcSession.connectedPeers[i].displayName)\n"
            }
            let ac = UIAlertController(title: "Peers list", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .cancel))
            self.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Peers list", message: "No peers connected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .cancel))
            self.present(ac, animated: true)
        }
    }
}

