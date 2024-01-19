import SwiftSyntax

extension InheritedTypeListSyntax {
    func remove(inheritedType protocolName: String) -> InheritedTypeListSyntax {
        InheritedTypeListSyntax(
            self
                .filter { $0.type.as(IdentifierTypeSyntax.self)?.name.text != protocolName }
                .mapLast { $0.with(\.trailingComma, nil) }
        )
    }
}
