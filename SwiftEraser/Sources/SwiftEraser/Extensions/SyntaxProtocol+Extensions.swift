import SwiftSyntax

extension SyntaxProtocol {
    var computedName: String? {
        if let decl = self.asProtocol(NamedDeclSyntax.self) {
            decl.name.text
        } else if let decl = self.as(ExtensionDeclSyntax.self) {
            decl.extendedType.as(IdentifierTypeSyntax.self)?.name.text
        } else if let decl = self.as(VariableDeclSyntax.self) {
            decl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        } else if let decl = self.as(CodeBlockItemSyntax.self) {
            decl.item.computedName
        } else {
            nil
        }
    }
}
