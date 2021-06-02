import Foundation
func camelCase(_ str: String) -> String {
    return str.capitalized.replacingOccurrences(of: str, with: .)
}

camelCase("Hello world, it's me")
