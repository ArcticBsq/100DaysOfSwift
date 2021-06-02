//
//  ViewController.swift
//  Project27
//
//  Created by Илья Москалев on 14.05.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    func drawRectangle() {
        let renderrer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderrer.image { ctx in
            // Drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
//            let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    // MARK: Wrap up рисуем звезду
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            let length = 150
            
            for _ in 0 ..< 6 {
                
                
                if first {
                    ctx.cgContext.rotate(by: 115)
                    ctx.cgContext.move(to: CGPoint(x: length, y: 45))
                    first = false
                } else {
                    ctx.cgContext.rotate(by: 54.035)
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 45))
                }
            }
            ctx.cgContext.setFillColor(UIColor.lightGray.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(3)
            
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    //MARK: Wrap up рисуем линиями(чтобы углы не были острыми на стыке - задай новую точку в координате стыка)
    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(3)
            
            // T code from point (50,256), крайняя точка x = 70
            ctx.cgContext.move(to: CGPoint(x: 50, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 50, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 30, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 70, y: 200))
            // W code
            ctx.cgContext.move(to: CGPoint(x: 100, y: 228))
            ctx.cgContext.addLine(to: CGPoint(x: 90, y: 256))
            ctx.cgContext.move(to: CGPoint(x: 90, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 80, y: 200))
            
            ctx.cgContext.move(to: CGPoint(x: 100, y: 228))
            ctx.cgContext.addLine(to: CGPoint(x: 110, y: 256))
            ctx.cgContext.move(to: CGPoint(x: 110, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 120, y: 200))
            // I cpde
            ctx.cgContext.move(to: CGPoint(x: 130, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 130, y: 200))
            // N code
            ctx.cgContext.move(to: CGPoint(x: 140, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 140, y: 200))
            ctx.cgContext.move(to: CGPoint(x: 140, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 170, y: 256))
            ctx.cgContext.move(to: CGPoint(x: 170, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 170, y: 200))
            
            
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    // MARK: Работа с текстом
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes of\nmice and men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageView.image = img
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawTWIN()
        
    }

    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawEmoji()
        case 1:
            drawRectangle()
        case 2:
            drawCircle()
        case 3:
            drawCheckerboard()
        case 4:
            drawRotatedSquares()
        case 5:
            drawLines()
        case 6:
            drawImagesAndText()
        default:
            break
        }
    }
    
    
}

