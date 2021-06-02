//
//  ViewController.swift
//  Project28
//
//  Created by Илья Москалев on 17.05.2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPassword))
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    @IBAction func authenticateTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] succress, authenticationError in
                DispatchQueue.main.async {
                    if succress {
                        self?.unlockSecretMessage()
                        // MARK: Wrap up 1 - next 1 line
                        self?.addLockButton()
                    } else {
                        // error
                        let ac = UIAlertController(title: "Aucthentication failed", message: "You could not be verified; enter password to see content", preferredStyle: .alert)
                        ac.addTextField()
                        ac.addAction(UIAlertAction(title: "Decline", style: .cancel))
                        ac.addAction(UIAlertAction(title: "Enter", style: .default, handler: { action in
                            guard let tryPass = ac.textFields?[0].text else { return }
                            
                            let password = KeychainWrapper.standard.string(forKey: "password") ?? ""
                            
                            if tryPass == password {
                                self?.unlockSecretMessage()
                            } else {
                                let ac = UIAlertController(title: "Incorrect password", message: nil, preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "Close", style: .cancel))
                            }
                        }))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biomety
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        // MARK: Wrap up 1 - next 1 line
        navigationItem.rightBarButtonItem = nil
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    // MARK: Wrap up 1 Showing lock button when unlocked and hiding it when locked
    func addLockButton() {
        let lockButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem = lockButton
    }
    
    // MARK: Wrap up 2 Creating password system if biometrics don't work
    @objc func addPassword() {
        let ac = UIAlertController(title: "Add password", message: "Create new password", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Save password", style: .default, handler: { action in
            guard let pass = ac.textFields?[0].text else { return }
            
            KeychainWrapper.standard.set(pass, forKey: "password")
        }))
        present(ac, animated: true)
    }

}

