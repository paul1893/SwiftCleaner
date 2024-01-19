import SwiftSyntax

extension DeclGroupSyntax where Self: DeclSyntaxProtocol {
    func without(property propertyName: String) -> Self {
        return self.with(
            \.memberBlock.members,
             MemberBlockItemListSyntax(
                memberBlock.members.removeProperties(matching: propertyName)
             )
        )
    }

    func without(function functionSignature: String, _ node: SwiftEraser.Node) -> Self {
        return self.with(
            \.memberBlock.members,
             MemberBlockItemListSyntax(
                memberBlock.members.removeFunctions(matching: functionSignature, node)
             )
        )
    }

    func without(functionSubscript functionSignature: String, _ node: SwiftEraser.Node) -> Self {
        return self.with(
            \.memberBlock.members,
             MemberBlockItemListSyntax(
                memberBlock.members.removeSubscripts(matching: functionSignature, node)
             )
        )
    }

    func without(functionConstructor functionSignature: String, _ node: SwiftEraser.Node) -> Self {
        return self.with(
            \.memberBlock.members,
             MemberBlockItemListSyntax(
                memberBlock.members.removeConstructors(matching: functionSignature, node)
             )
        )
    }

    func without(protocolConformance protocolName: String) -> Self {
        guard let inheritanceClause = self.inheritanceClause else {
            return self
        }
        let newInheritedTypes = inheritanceClause.inheritedTypes.remove(inheritedType: protocolName)
        if newInheritedTypes.isEmpty {
            if let _ = self.genericWhereClause {
                return self
                    .with(\.inheritanceClause, nil)
                    .with(\.genericWhereClause!.leadingTrivia, .space)
            } else {
                return self
                    .with(\.inheritanceClause, nil)
            }
        } else {
            return self.with(
                \.inheritanceClause,
                 inheritanceClause.with(
                    \.inheritedTypes,
                     newInheritedTypes
                 )
            )
        }
    }
}
