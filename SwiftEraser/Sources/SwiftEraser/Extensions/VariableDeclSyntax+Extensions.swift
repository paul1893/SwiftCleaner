import SwiftSyntax

private extension PatternBindingListSyntax.Element {
    var name: String? {
        self
            .pattern
            .as(IdentifierPatternSyntax.self)?
            .identifier
            .text
    }
}
extension VariableDeclSyntax {
    var name: TokenSyntax? {
        bindings
            .first?
            .pattern
            .cast(IdentifierPatternSyntax.self)
            .identifier
    }

    func matching(_ propertyName: String) -> Bool {
        let matched = bindings
            .contains(where: { patternBindingSyntax in
                guard let patternBindingSyntax = patternBindingSyntax.as(PatternBindingSyntax.self)
                else {
                    return false
                }

                /*let typeName = patternBindingSyntax
                    .typeAnnotation?
                    .as(TypeAnnotationSyntax.self)?
                    .type
                    .as(IdentifierTypeSyntax.self)?
                    .name
                    .text
                let someOrAnyTypeName = patternBindingSyntax
                    .typeAnnotation?
                    .as(TypeAnnotationSyntax.self)?
                    .type
                    .as(SomeOrAnyTypeSyntax.self)?
                    .constraint
                    .as(IdentifierTypeSyntax.self)?
                    .name
                    .text
                let optionalTypeName = patternBindingSyntax
                    .typeAnnotation?
                    .as(TypeAnnotationSyntax.self)?
                    .type
                    .as(OptionalTypeSyntax.self)?
                    .wrappedType
                    .as(IdentifierTypeSyntax.self)?
                    .name
                    .text
                let someOrAnyOptionalTypeName = patternBindingSyntax
                    .typeAnnotation?
                    .as(TypeAnnotationSyntax.self)?
                    .type
                    .as(OptionalTypeSyntax.self)?
                    .wrappedType
                    .as(TupleTypeSyntax.self)?
                    .elements
                    .first?
                    .type
                    .as(SomeOrAnyTypeSyntax.self)?
                    .constraint
                    .as(IdentifierTypeSyntax.self)?
                    .name
                    .text
                let safeTypeName = typeName ?? someOrAnyTypeName ?? optionalTypeName ?? someOrAnyOptionalTypeName
                guard let safeTypeName else {
                    return false
                }
                // ⚠️ TODO
                /*let typeMatched = collectedRemovedProtocols.contains(safeTypeName)*/
                return typeMatched && patternBindingSyntax.name == propertyName*/
                return patternBindingSyntax.name == propertyName
            }) == true
        return matched
    }
}
