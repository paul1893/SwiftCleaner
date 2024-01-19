import Foundation

enum Periphery {
    struct JSONNode: Codable {
        let name: String
        let modifiers: [Accessibility]
        let accessibility: Accessibility
        let location: String
        let modules: [String]?
        let kind: Kind
        let attributes: [String]
        let ids: [String]
        let hints: [Hint]

        enum Accessibility: String, Codable {
            case accessibilityConvenience = "convenience"
            case accessibilityFinal = "final"
            case accessibilityInternal = "internal"
            case accessibilityLazy = "lazy"
            case accessibilityPrivate = "private"
            case accessibilityPublic = "public"
            case accessibilityRequired = "required"
            case accessibilityStatic = "static"
            case accessibilityWeak = "weak"
            case accessibilityOverride = "override"
            case accessibilityFileprivate = "fileprivate"
            case accessibilityOpen = "open"
            case accessibilityMutating = "mutating"
            case empty = ""
        }

        enum Hint: String, Codable {
            case assignOnlyProperty = "assignOnlyProperty"
            case redundantConformance = "redundantConformance"
            case redundantProtocol = "redundantProtocol"
            case redundantPublicAccessibility = "redundantPublicAccessibility"
            case unused = "unused"
        }

        enum Kind: String, Codable {
            case `associatedtype` = "associatedtype"
            case `class` = "class"
            case `enum` = "enum"
            case enumelement = "enumelement"
            case `extension` = "extension"
            case extensionClass = "extension.class"
            case extensionEnum = "extension.enum"
            case extensionProtocol = "extension.protocol"
            case extensionStruct = "extension.struct"
            case functionAccessorAddress = "function.accessor.address"
            case functionAccessorDidset = "function.accessor.didset"
            case functionAccessorGetter = "function.accessor.getter"
            case functionAccessorMutableaddress = "function.accessor.mutableaddress"
            case functionAccessorSetter = "function.accessor.setter"
            case functionAccessorWillset = "function.accessor.willset"
            case functionConstructor = "function.constructor"
            case functionDestructor = "function.destructor"
            case functionFree = "function.free"
            case functionMethodClass = "function.method.class"
            case functionMethodInstance = "function.method.instance"
            case functionMethodStatic = "function.method.static"
            case functionOperator = "function.operator"
            case functionOperatorInfix = "function.operator.infix"
            case functionOperatorPostfix = "function.operator.postfix"
            case functionOperatorPrefix = "function.operator.prefix"
            case functionSubscript = "function.subscript"
            case genericTypeParam = "generic_type_param"
            case module = "module"
            case precedenceGroup = "precedencegroup"
            case `protocol` = "protocol"
            case `struct` = "struct"
            case `typealias` = "typealias"
            case varClass = "var.class"
            case varGlobal = "var.global"
            case varInstance = "var.instance"
            case varLocal = "var.local"
            case varParameter = "var.parameter"
            case varStatic = "var.static"
        }
    }
}
