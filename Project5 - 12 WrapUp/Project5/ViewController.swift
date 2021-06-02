//
//  ViewController.swift
//  Project5
//
//  Created by Илья Москалев on 02.03.2021.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    var gameData = GameData(currentWord: "", usedWords: [String]())
    var gameDataKey = "GameData"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .done, target: self, action: #selector(startGame))
    }

    @objc func loadData() {
        let userDefaults = UserDefaults.standard
        if let loadedData = userDefaults.object(forKey: gameDataKey) as? Data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(GameData.self, from: loadedData) {
                gameData = decodedData
            }
        }
        
        if gameData.currentWord.isEmpty {
            performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(loadGameDataView), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func saveGameData() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(gameData) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: gameDataKey)
        }
    }
    
    @objc func loadGameDataView() {
        title = gameData.currentWord
        tableView.reloadData()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        
        self.saveGameData()
        self.loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased() // Проверка слова, делаем все буквы строчными, чтобы не было CaSE CasE и прочего
        
        if isPossible(word: lowerAnswer) { // Проверка трех условий, если все true, то продолжаем работать
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    gameData.usedWords.insert(answer, at: 0) // Добавляем правильное слово в массив использованных слов под индексом 0, чтобы в tableView оно появилось сверху
                    self.saveGameData()
                    
                    let indexPath = IndexPath(row: 0, section: 0) // Создаем путь для добавления новой ячейки с нашим словом
                    tableView.insertRows(at: [indexPath], with: .automatic) // Собственно само добавление at: наш адрес и with: анимация
                    
                    return
                } else {
                    showErrorMessage(title: "Word not recognised", message: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(title: "Word used already", message: "Be more original!")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title)")
        }
    }
    
    func isPossible(word: String) -> Bool { // Можно ли составить слово из выпавшего нам по Игре
        guard var tempWord = title?.lowercased() else { return false } // Выделяем наше Игровое слово из title
        
        for letter in word { // Проверка по букве
            if let position = tempWord.firstIndex(of: letter) { // Проверяем каждую букву в слове на наличие в Игровом слове, если она есть - возвращаем ее индес, если нет - false
                tempWord.remove(at: position) // Если буква есть, то из нашего Игрового слова ее удаляем, чтобы не использовать повторно
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool { // Было ли это слово уже использовано?
        return !usedWords.contains(word) // ! здесь означает НЕ
    }
    
    func isReal(word: String) -> Bool { // Действительно существует такое слово?
        if word.count < 3 || word == title {
            return false
        }
        let checker = UITextChecker() // Элемент UI отвечающий за проверку слова
        let range = NSRange(location: 0, length: word.utf16.count) // Создаем диапазон, где стартовая точка = 0, а конечная = длине слова
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en") // Здесь мы и проверяем есть ли влово, 1 и 2 параметры, 5 параметр.
        // Оно задает misspelledRange значение NSRange, но если слово слово существует, значение будет NSNotfound
        return misspelledRange.location == NSNotFound // тут мы и проверяем есть слово или нет
    }
    
    func showErrorMessage(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction((UIAlertAction(title: "OK", style: .cancel)))
        present(ac, animated: true)
    }
    
    func save() {
        let userDefaults = UserDefaults.standard
        
    }
}


