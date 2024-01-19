import SwiftSyntax

extension CodeBlockItemListSyntax.Element {
    var hasNoMembers: Bool {
        self.item.declGroupSyntaxProtocol?.memberBlock.members.isEmpty == true
    }

    var name: String? {
        if let declaration = self.item.asProtocol(NamedDeclSyntax.self) {
            return declaration.name.text.trimmingCharacters(in: .whitespaces)
        }
        if let declaration = self.item.as(ExtensionDeclSyntax.self) {
            return declaration.extendedType.description.trimmingCharacters(in: .whitespaces)
        }
        return nil
    }

    func applyTransitivity(for `protocol`: ProtocolDeclSyntax) -> Self {
        if let declGroup = self.item.asProtocol(DeclGroupSyntax.self),
           inheritedTypes?.contains(where: { $0.type.as(IdentifierTypeSyntax.self)?.name.text == `protocol`.name.text }) == true
        {
            return CodeBlockItemListSyntax.Element(item:
                    .decl(
                        declGroup
                            .with(
                                \.inheritanceClause,
                                 `protocol`.inheritanceClause
                            )
                            .with(
                                \.genericWhereClause,
                                 `protocol`.genericWhereClause
                            )
                            .cast(DeclSyntax.self)
                    )
            )
        } else {
            return self
        }
    }
}
