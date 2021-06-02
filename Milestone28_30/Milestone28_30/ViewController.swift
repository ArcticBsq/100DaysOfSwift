//
//  ViewController.swift
//  Milestone28_30
//
//  Created by Илья Москалев on 19.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var allButtonsArray: [UIButton]!
    
    var currentArrayOfWords = [String]()
    
//    var activatedButtons = [UIButton]()
    var activatedButtonIndicies = [Int]()
    
    var deletedButtons = [UIButton]()
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let listOfAllLevelsButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openAllWords))
        let shareAppButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        let lockButton = UIBarButtonItem(title: "Lock", style: .done, target: self, action: #selector(lockScreen))
        
        navigationItem.rightBarButtonItems = [listOfAllLevelsButton, shareAppButton]
        navigationItem.leftBarButtonItems = [lockButton]
        
        loadWords()
        loadButtons()
        addWordsToButtons()
        
    }

    
    
    
    @IBAction func tapButton(_ sender: UIButton) {
        let index = allButtonsArray.firstIndex(of: sender)!
        
        if activatedButtonIndicies.count < 2 {
//        if activatedButtons.count < 2 {
//            activatedButtons.append(sender)
            activatedButtonIndicies.append(index)
            
            sender.isUserInteractionEnabled = false
            sender.titleLabel?.layer.opacity = 1
        } else {
            sender.titleLabel?.layer.opacity = 1
            
            sender.isUserInteractionEnabled = false
            
            
            if allButtonsArray[activatedButtonIndicies[0]].title(for: .normal) == allButtonsArray[activatedButtonIndicies[1]].title(for: .normal) {
                
//            if activatedButtons[0].title(for: .normal) == activatedButtons[1].title(for: .normal) {
                allButtonsArray[activatedButtonIndicies[0]].isUserInteractionEnabled = false
                allButtonsArray[activatedButtonIndicies[0]].isHidden = true
//                activatedButtons[0].isUserInteractionEnabled = false
//                activatedButtons[0].isHidden = true

                allButtonsArray[activatedButtonIndicies[1]].isUserInteractionEnabled = false
                allButtonsArray[activatedButtonIndicies[1]].isHidden = true
//                activatedButtons[1].isUserInteractionEnabled = false
//                activatedButtons[1].isHidden = true
                deletedButtons.append(allButtonsArray[activatedButtonIndicies[0]])
                deletedButtons.append(allButtonsArray[activatedButtonIndicies[1]])
//                deletedButtons.append(activatedButtons[0])
//                deletedButtons.append(activatedButtons[1])
                activatedButtonIndicies.removeAll()
                activatedButtonIndicies.append(index)
//                activatedButtons.removeAll()
//                print(activatedButtons)
//                activatedButtons.append(sender)
                score += 100
            } else {
                allButtonsArray[activatedButtonIndicies[0]].titleLabel?.layer.opacity = 0
                allButtonsArray[activatedButtonIndicies[1]].titleLabel?.layer.opacity = 0
//                activatedButtons[0].titleLabel?.layer.opacity = 0
//                activatedButtons[1].titleLabel?.layer.opacity = 0
                allButtonsArray[activatedButtonIndicies[0]].isUserInteractionEnabled = true
                allButtonsArray[activatedButtonIndicies[1]].isUserInteractionEnabled = true
//                activatedButtons[0].isUserInteractionEnabled = true
//                activatedButtons[1].isUserInteractionEnabled = true
                activatedButtonIndicies.removeAll()
                activatedButtonIndicies.append(index)
//                activatedButtons.removeAll()
//                print(activatedButtons)
//                activatedButtons.append(sender)
                score -= 50
            }
        }
        
    }
    // 1
    func loadWords() {
        currentArrayOfWords = ["This", "is", "array", "of", "Six", "words"]
        currentArrayOfWords += currentArrayOfWords
        currentArrayOfWords.shuffle()
    }
    // 2
    func loadButtons() {
        for button in allButtonsArray {
            button.isHidden = false
            button.backgroundColor = UIColor.systemGray
        }
    }
    // 3
    func addWordsToButtons() {
        for (index, button) in allButtonsArray.enumerated() {
            button.setTitle(currentArrayOfWords[index], for: .normal)
            button.titleLabel?.layer.opacity = 0.0
        }
    }
    
    // MARK: Добавить функции для кнопок navigation bar
    @objc func openAllWords() { // Открывает tableView в котором хранятсяуровни
        
    }
    
    @objc func shareApp() { // Делимся приложением
        
    }
    
    @objc func lockScreen() { // Блокировка приложения, нужна будет биометрия для разблока
        
    }
    
}

