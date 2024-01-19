import SwiftSyntax

extension ProtocolDeclSyntax {
    func removeAssociatedTypesIfNeeded() -> Self {
        var collectedTypes = [TokenSyntax]()
        // Collect types for variables & parameters
        for member in memberBlock.members {
            if let variableDeclSyntax = member.decl.as(VariableDeclSyntax.self) {
                let declWhenInitializer = variableDeclSyntax
                    .bindings
                    .first?
                    .initializer?
                    .value
                    .as(FunctionCallExprSyntax.self)?
                    .calledExpression
                    .as(DeclReferenceExprSyntax.self)?
                    .baseName
                let declWhenTypeAnnotation = variableDeclSyntax
                    .bindings
                    .first?
                    .typeAnnotation?
                    .type
                    .as(IdentifierTypeSyntax.self)?
                    .name
                collectedTypes.append(
                    contentsOf: [declWhenInitializer, declWhenTypeAnnotation].compactMap { $0 }
                )
            }
            // InitializerDeclSyntax && FunctionDeclSyntax
            if let initializerDeclSyntax = member.decl.as(InitializerDeclSyntax.self) {
                let parametersIdentifierTypes = initializerDeclSyntax
                    .signature
                    .parameterClause
                    .parameters
                    .compactMap {
                        $0.type.as(IdentifierTypeSyntax.self)?.name
                    }
                collectedTypes.append(contentsOf: parametersIdentifierTypes)
            }
            if let functionDeclSyntax = member.decl.as(FunctionDeclSyntax.self) {
                let parametersIdentifierTypes = functionDeclSyntax
                    .signature
                    .parameterClause
                    .parameters
                    .compactMap {
                        $0.type.as(IdentifierTypeSyntax.self)?.name
                    }
                collectedTypes.append(contentsOf: parametersIdentifierTypes)
            }
        }
        // Remove unused associatedType
        return self.with(
            \.memberBlock.members,
             MemberBlockItemListSyntax(
                memberBlock.members.compactMap { member -> MemberBlockItemListSyntax.Element? in
                    if let associatedType = member
                        .decl
                        .as(AssociatedTypeDeclSyntax.self),
                       collectedTypes
                        .map(\.text)
                        .contains(associatedType.name.text) == false {
                        return nil
                    } else {
                        return member
                    }
                }
             )
        )
    }
}
