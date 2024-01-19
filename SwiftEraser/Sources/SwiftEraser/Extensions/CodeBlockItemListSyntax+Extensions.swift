import SwiftSyntax

extension CodeBlockItemListSyntax {
    func grouping(byConformingTo conforms: String) -> [String: any DeclGroupSyntax] {
        var result = [String: any DeclGroupSyntax]()
        for element in self {
            guard let declGroup = element.item.asProtocol(DeclGroupSyntax.self) else {
                continue
            }
            for member in declGroup.memberBlock.members {
                guard let declMemberGroup = member.decl.asProtocol(DeclGroupSyntax.self) else {
                    continue
                }
                if declMemberGroup
                    .inheritanceClause?
                    .inheritedTypes
                    .contains(where: { $0.type.as(IdentifierTypeSyntax.self)?.name.text == conforms }) == true
                {
                    var parent = member.parent
                    repeat {
                        parent = parent?.parent
                    } while parent?.asProtocol(NamedDeclSyntax.self) == nil && parent?.as(ExtensionDeclSyntax.self) == nil
                    if let nameDecl = parent?.computedName {
                        result[nameDecl] = declMemberGroup
                    }
                } else {
                    continue
                }
            }
        }
        return result
    }
}
