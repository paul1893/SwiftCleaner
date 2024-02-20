import Foundation

extension [Periphery.JSONNode.Hint] {
    func contains(_ hint: Periphery.JSONNode.Hint) -> Bool {
        self.contains(where: { $0.rawValue == hint.rawValue })
    }
}
