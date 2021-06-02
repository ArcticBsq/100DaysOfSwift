//
//  ViewController.swift
//  Project2
//
//  Created by Илья Москалев on 21.02.2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // Массив стран
    var countries = [String]()
    // Считаем очки
    var score = 0
    // Переменная отвечает за идентификацию правильного ответа
    var correctAnswer = 0
    // Считаем сколько всего задано вопросов
    var questionsAsked = 0
    // Считаем сколько всего правильных ответов
    var totalAnswered = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .done, target: self, action: #selector(showScore))

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        // Выделяем границы Button
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        // Меняем цвет границ Button
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        registerLoad()
        scheduleLocal()
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            self.button1.transform = .identity
            self.button2.transform = .identity
            self.button3.transform = .identity
            
        }) { finished in
            
        }
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].uppercased() + " Your score is \(score)"
        questionsAsked += 1
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }) { finished in
            
        }
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            totalAnswered += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        // Создаем окно для алерта для кждого нажатия на флаг
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        // Добавляем кнопку Continue в алерт = привязываем к ней метод askQuestion
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // Создаем окно для алерта неправильного ответа
        let wrongController = UIAlertController(title: title, message: "Wrong, it's the flag of \(countries[correctAnswer].uppercased())", preferredStyle: .alert)
        wrongController.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: askQuestion))
        // Создаем окно для алерта каждые 10 вопросов
        let questionAlertController = UIAlertController(title: "10 questions slice", message: "You have answered \(totalAnswered) / \(questionsAsked)", preferredStyle: .alert)
        // Добавляем кнопку Continue в алерт для каждых 10 вопросов
        questionAlertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // Проверка для вызова нужного алерта
        if questionsAsked % 10 == 0 {
            present(questionAlertController, animated: true)
        } else if sender.tag == correctAnswer {
            // Вызов алерта на экран
            askQuestion()
        } else {
            present(wrongController, animated: true)
        }
    }
    @objc func showScore() {
        let vc = UIAlertController(title: "Your score is \(score)", message: nil, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Resume", style: .default))
        present(vc, animated: true)
    }
    //MARK: notofocations
    public func registerLoad() {
        let centet = UNUserNotificationCenter.current()
        centet.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications allowed")
            } else {
                print("Notofocations disAllowed")
            }
        }
    }
    
    func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        var isRepeating = true
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 18
        dateComponents.second = 25
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeating)
        
        let content = UNMutableNotificationContent()
        content.title = "Hi there!"
        content.body = "Come back to guess more flags!"
        content.categoryIdentifier = "everyDayAlert"
        content.userInfo = ["customData" : "bzz"]
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Let's go", options: .foreground)
        let remindLater = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            switch response.actionIdentifier {
            case "show":
                print("Show case tapped")
            case UNNotificationDefaultActionIdentifier:
                print("Default action was tapped")
            case "remind":
                print("Remind case was taped")
                DispatchQueue.main.async {
                    self.scheduleLocal()
                }
            default:
                print("Case default")
                break
            }
        }
    completionHandler()
    }
}

