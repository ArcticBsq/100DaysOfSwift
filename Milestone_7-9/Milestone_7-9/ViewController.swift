//
//  ViewController.swift
//  Milestone_7-9
//
//  Created by Илья Москалев on 10.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var guessWordLabel: UILabel!
    
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y"]
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var words = ["RICHARD", "PUKKI", "ALENA", "ILIA", "APPLE", "IMAC", "GRANDORF"]
    var currentWord: String = "silkworm"
    var lives = 0
    var correctLetters = [String]()
    var score = 0 {
        didSet {
            title = "Score: \(score)"
        }
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35), .foregroundColor: UIColor.white]
        
        guessWordLabel = UILabel()
        guessWordLabel.translatesAutoresizingMaskIntoConstraints = false
        guessWordLabel.textAlignment = .center
        guessWordLabel.font = UIFont.systemFont(ofSize: 25)
        guessWordLabel.text = ""
        view.addSubview(guessWordLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        guessWordLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonsView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        NSLayoutConstraint.activate([
            guessWordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            guessWordLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            guessWordLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2),
            guessWordLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5)
        ])
        let width = 80
        let height = 80
        
        for row in 0..<5 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                letterButton.setTitle("X", for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadGame()
    }
    
    @objc func loadGame() {
        currentWord = words[Int.random(in: 0..<words.count)].uppercased()
        lives = 7
        guessWordLabel.text = String(repeating: "_ ", count: currentWord.count).trimmingCharacters(in: .whitespaces)
        
        title = "Score: \(score)"
        
        activatedButtons = [UIButton]()
        correctLetters = [String]()
        
        for button in letterButtons {
            button.isHidden = false
        }
        
        for i in 0 ..< letterButtons.count {
            letterButtons[i].setTitle(letters[i], for: .normal)
        }
        
        
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if currentWord.contains(buttonTitle) {
            correctLetters.append(buttonTitle)
            correctLetter()
            
            activatedButtons.append(sender)
            sender.isHidden = true
            
        } else {
            incorrectLetter()
            activatedButtons.append(sender)
            sender.isHidden = true
        }
    }
    
    func correctLetter() {
        var wordText = ""
        var wordComplete = true
        
        for ltr in currentWord {
            let strLetter = String(ltr)
            if correctLetters.contains(strLetter) {
                wordText += "\(strLetter) "
            } else {
                wordText += "_ "
                wordComplete = false
            }
        }
        
        guessWordLabel.text = wordText.trimmingCharacters(in: .whitespaces)
        
        if wordComplete {
            for button in activatedButtons {
                button.isHidden = false
            }
            
            score += 2
            
            let ac = UIAlertController(title: "Gratz", message: "You answered the word!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default))
            ac.addAction(UIAlertAction(title: "Go next", style: .default))
            present(ac, animated: true)
        }
    }
    
    func incorrectLetter() {
        lives -= 1
        
        if lives == 0 {
            let ac = UIAlertController(title: "Oooops", message: "You lost!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New game!", style: .default))
            ac.addAction(UIAlertAction(title: "Close", style: .default))
            present(ac, animated: true)
        }
    }
}
