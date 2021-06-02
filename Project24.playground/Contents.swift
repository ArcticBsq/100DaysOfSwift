import UIKit

let string = "This is test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let mutableAttributedString = NSMutableAttributedString(string: string)
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 4))

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}

var amigo = "Antwood"
amigo.withPrefix("Ant")
amigo.withPrefix("Die")


extension String {
//    func isNumeric() -> Bool {
//        let nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
//        for item in nums {
//            if self.contains(item) {
//                return true
//            }
//        }
//        return false
//    }
    var isNumeric: Bool {
        let numbers = "1234567890"
        return self.contains(where: numbers.contains)
    }
}

let satehi = "Hello, World!"
let numSatehi = "H3ll0 W0r1d!"

satehi.isNumeric
numSatehi.isNumeric

extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}
satehi.lines
let satehiLined = "Hello, World!\nI really enjoy\nLearningSwift!"
satehiLined.lines
