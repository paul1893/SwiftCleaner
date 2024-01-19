import SwiftSyntax

extension EnumDeclSyntax {
    func without(case: String) -> Self {
        self.with(
            \.memberBlock.members,
             self.memberBlock.members.filter {
                 $0
                     .as(MemberBlockItemSyntax.self)?
                     .decl
                     .as(EnumCaseDeclSyntax.self)?
                     .elements
                     .first?
                     .as(EnumCaseElementSyntax.self)?
                     .name
                     .text != `case`
             }
        )
    }
}
