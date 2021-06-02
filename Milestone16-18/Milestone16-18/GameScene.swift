//
//  GameScene.swift
//  Milestone16-18
//
//  Created by Илья Москалев on 26.04.2021.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var reloadLabel: SKLabelNode!
    var bulletsLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    
    var leftBullet: SKSpriteNode!
    var rightBullet: SKSpriteNode!
    
    var rowCGPoints = [CGFloat]()
    
    var createDuckTimer: Timer?
    var countDownTimer: Timer?
    var countDownSeconds = 100
    
    var isGameOver = false
    var bullets = 6 {
        didSet {
            updateBulletsView()
            print(bullets)
        }
    }
    
    var score: Double = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
   
    var possibleTargets = ["target0", "target1", "target2", "target3"]
    
    override func didMove(to view: SKView) {
        let woodenBackground = SKSpriteNode(imageNamed: "wood-background")
        woodenBackground.position = CGPoint(x: 512, y: 384)
        woodenBackground.blendMode = .replace
        woodenBackground.zPosition = -4
        woodenBackground.name = "textures"
        woodenBackground.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        addChild(woodenBackground)
        
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.name = "textures"
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.zPosition = -1
        curtains.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        addChild(curtains)
        
        waterRow(at: CGPoint(x: 512, y: 170))
        waterRow(at: CGPoint(x: 512, y: 320))
        waterRow(at: CGPoint(x: 512, y: 470))
        
        scoreLabel = SKLabelNode(fontNamed: "Apple SD Gothic Neo")
        scoreLabel.position = CGPoint(x: 50, y: 685)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 55
        scoreLabel.name = "textures"
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Apple SD Gothic Neo")
        timerLabel.position = CGPoint(x: 512, y: 650)
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.text = "60"
        timerLabel.fontSize = 100
        addChild(timerLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Apple SD Gothic Neo")
        newGameLabel.position = CGPoint(x: 900, y: 685)
        newGameLabel.horizontalAlignmentMode = .center
        newGameLabel.text = "New game"
        newGameLabel.fontSize = 55
        addChild(newGameLabel)
        
        reloadLabel = SKLabelNode(fontNamed: "Apple SD Gothic Neo")
        reloadLabel.position = CGPoint(x: 100, y: 100)
        reloadLabel.text = "Reload"
        reloadLabel.fontSize = 55
        reloadLabel.name = "reload"
        addChild(reloadLabel)
        
        leftBullet = SKSpriteNode(imageNamed: "shots3")
        leftBullet.position = CGPoint(x: 458, y: 100)
        leftBullet.size = CGSize(width: 100, height: 90)
        addChild(leftBullet)
        
        rightBullet = SKSpriteNode(imageNamed: "shots3")
        rightBullet.position = CGPoint(x: 566, y: 100)
        rightBullet.size = CGSize(width: 100, height: 90)
        addChild(rightBullet)
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDownTimer), userInfo: nil, repeats: true)
        updateTimer(newInterval: 0.7)
    }
    
    func waterRow(at position: CGPoint) {
        let waterLine = SKSpriteNode(imageNamed: "water-bg")
        waterLine.position = position
        waterLine.size = CGSize(width: 1024, height: 50)
        waterLine.zPosition = -3
        addChild(waterLine)
        rowCGPoints.append(position.y)
    }
  // MARK: Creating ducks
    @objc func createDuck() {
        if !isGameOver {
        let yPositions = [200, 350, 500]
        let ratio = [0.5, 1, 2]
        
        let spriteImageName = possibleTargets.randomElement() ?? "target1"
        
        let spriteSizeRatio = ratio.randomElement() ?? 1
        
        let sprite = SKSpriteNode(imageNamed: spriteImageName)
        
        let yPos = yPositions.randomElement() ?? 350
        
        switch spriteImageName {
        case "target0":
            sprite.name = "enemy"
        case "target1":
            sprite.name = "friend"
        case "target2":
            sprite.name = "enemy"
        case "target3":
            sprite.name = "friend"
        default:
            break
        }
        
        switch spriteSizeRatio {
        case 0.5:
            sprite.size = CGSize(width: 50, height: 50)
            sprite.name! += "2"
        case 1:
            sprite.size = CGSize(width: 100, height: 100)
            sprite.name! += "1"
        case 2:
            sprite.size = CGSize(width: 150, height: 150)
            sprite.name! += "0.5"
        default:
            break
        }
        
        sprite.zPosition = -2
        
        if yPos == 350 {
            sprite.position = CGPoint(x: 0, y: yPos)
            addChild(sprite)
            sprite.run(SKAction.sequence([SKAction.moveBy(x: 1300, y: 0, duration: 5), SKAction.removeFromParent()]))
        } else {
            sprite.position = CGPoint(x: 1024, y: yPos)
            addChild(sprite)
            sprite.run(SKAction.sequence([SKAction.moveBy(x: -1000, y: 0, duration: 5), SKAction.removeFromParent()]))
        }
        }
    }
    
 // MARK: Work with Timers
    func updateTimer(newInterval: TimeInterval) {
        createDuckTimer?.invalidate()
        createDuckTimer = Timer.scheduledTimer(timeInterval: newInterval, target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountDownTimer() {
        if countDownSeconds > 0 {
            countDownSeconds -= 1
            timerLabel.text = String(countDownSeconds)
        } else {
            countDownTimer?.invalidate()
            isGameOver = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
 // MARK: Updating bullets pictures
    func updateBulletsView() {
        switch bullets {
        case 6:
            leftBullet.texture = SKTexture(imageNamed: "shots3")
            rightBullet.texture = SKTexture(imageNamed: "shots3")
            print("case 6")
        case 5:
            leftBullet.texture = SKTexture(imageNamed: "shots3")
            rightBullet.texture = SKTexture(imageNamed: "shots2")
            print("case 5")
        case 4:
            leftBullet.texture = SKTexture(imageNamed: "shots3")
            rightBullet.texture = SKTexture(imageNamed: "shots1")
            print("case 4")
        case 3:
            leftBullet.texture = SKTexture(imageNamed: "shots3")
            rightBullet.texture = SKTexture(imageNamed: "shots0")
            print("case 3")
        case 2:
            leftBullet.texture = SKTexture(imageNamed: "shots2")
            rightBullet.texture = SKTexture(imageNamed: "shots0")
            print("case 2")
        case 1:
            leftBullet.texture = SKTexture(imageNamed: "shots1")
            rightBullet.texture = SKTexture(imageNamed: "shots0")
        case 0:
            leftBullet.texture = SKTexture(imageNamed: "shots0")
            rightBullet.texture = SKTexture(imageNamed: "shots0")
        default:
            bullets = 0
            leftBullet.texture = SKTexture(imageNamed: "shots0")
            rightBullet.texture = SKTexture(imageNamed: "shots0")
        }
    }
// MARK: Work with touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        if !isGameOver {
            if bullets == 0 {
            for node in touchedNodes {
                if node.name == "reload" {
                    bullets = 6
                }
            }
            } else  {
                bullets -= 1
            if bullets > 0 {
                
                for node in touchedNodes {
                    switch node.name {
                    case "friend0.5":
                        score += 0.5
                        node.removeFromParent()
                    case "friend1":
                        score += 1
                        node.removeFromParent()
                    case "friend2":
                        score += 2
                        node.removeFromParent()
                    case "enemy0.5":
                        score -= 0.5
                        node.removeFromParent()
                    case "enemy1":
                        score -= 1
                        node.removeFromParent()
                    case "enemy2":
                        score -= 2
                        node.removeFromParent()
                    default:
                        print(node.name)
                    }
                }
            }
        }
    }
}
}
