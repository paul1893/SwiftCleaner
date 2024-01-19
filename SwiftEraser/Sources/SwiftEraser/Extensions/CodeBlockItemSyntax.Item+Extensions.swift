import SwiftSyntax

extension CodeBlockItemSyntax.Item {
    func `is`(into parentNode: Syntax?) -> Bool {
        syntaxNodeType == parentNode?.syntaxNodeType
        && self.computedName == parentNode?.computedName
    }

    var declGroupSyntaxProtocol: (any DeclGroupSyntaxProtocol)? {
        switch self {
        case .decl(let declSyntax):
            if let result = declSyntax.as(ActorDeclSyntax.self) {
                return result
            }
            if let result = declSyntax.as(ClassDeclSyntax.self) {
                return result
            }
            if let result = declSyntax.as(StructDeclSyntax.self) {
                return result
            }
            if let result = declSyntax.as(EnumDeclSyntax.self) {
                return result
            }
            if let result = declSyntax.as(ExtensionDeclSyntax.self) {
                return result
            }
            if let result = declSyntax.as(ProtocolDeclSyntax.self) {
                return result
            }
            return (any DeclGroupSyntaxProtocol)?.none
        case .stmt, .expr:
            return (any DeclGroupSyntaxProtocol)?.none
        }
    }
}
