import SwiftSyntax

extension CodeBlockItemSyntax {
    var isConformingToProtocol: Bool {
        if let inheritedTypes = self.inheritedTypes {
            inheritedTypes.count != 0
        } else {
            false
        }
    }

    var isProtocol: Bool {
        self.as(ProtocolDeclSyntax.self) != nil
        || self.as(CodeBlockItemSyntax.self)?.item.as(ProtocolDeclSyntax.self) != nil
    }

    var inheritedTypes: InheritedTypeListSyntax? {
        if let inheritedTypes = self.item.asProtocol(DeclGroupSyntax.self)?.inheritanceClause?.inheritedTypes {
            inheritedTypes
        } else if let inheritedTypes = self.asProtocol(DeclGroupSyntax.self)?.inheritanceClause?.inheritedTypes {
            inheritedTypes
        } else {
            nil
        }
    }

    func map<T: DeclSyntaxProtocol>(_ transform: () -> T) -> Self {
        return self.with(
            \.item,
             CodeBlockItemSyntax.Item.decl(
                DeclSyntax(
                    transform()
                )
             )
        )
    }

    func map(_ transform: () -> any DeclSyntaxProtocol) -> Self {
        return self.with(
            \.item,
             CodeBlockItemSyntax.Item.decl(
                DeclSyntax(
                    transform()
                )
             )
        )
    }
}
