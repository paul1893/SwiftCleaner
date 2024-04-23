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

        enum Accessibility: Codable, RawRepresentable, Equatable {
            case accessibilityConvenience
            case accessibilityFinal
            case accessibilityInternal
            case accessibilityLazy
            case accessibilityPrivate
            case accessibilityPublic
            case accessibilityRequired
            case accessibilityStatic
            case accessibilityWeak
            case accessibilityOverride
            case accessibilityFileprivate
            case accessibilityOpen
            case accessibilityMutating
            case empty
            case unsupported(String)
            
            private enum CodingKeys: CodingKey {}
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let decodedString = try container.decode(String.self)
                
                switch decodedString {
                    case "convenience":
                        self = .accessibilityConvenience
                    case "final":
                        self = .accessibilityFinal
                    case "internal":
                        self = .accessibilityInternal
                    case "lazy":
                        self = .accessibilityLazy
                    case "private":
                        self = .accessibilityPrivate
                    case "public":
                        self = .accessibilityPublic
                    case "required":
                        self = .accessibilityRequired
                    case "static":
                        self = .accessibilityStatic
                    case "weak":
                        self = .accessibilityWeak
                    case "override":
                        self = .accessibilityOverride
                    case "fileprivate":
                        self = .accessibilityFileprivate
                    case "open":
                        self = .accessibilityOpen
                    case "mutating":
                        self = .accessibilityMutating
                    case "":
                        self = .empty
                    default:
                        self = .unsupported(decodedString)
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                
                switch self {
                    case .accessibilityConvenience:
                        try container.encode("convenience")
                    case .accessibilityFinal:
                        try container.encode("final")
                    case .accessibilityInternal:
                        try container.encode("internal")
                    case .accessibilityLazy:
                        try container.encode("lazy")
                    case .accessibilityPrivate:
                        try container.encode("private")
                    case .accessibilityPublic:
                        try container.encode("public")
                    case .accessibilityRequired:
                        try container.encode("required")
                    case .accessibilityStatic:
                        try container.encode("static")
                    case .accessibilityWeak:
                        try container.encode("weak")
                    case .accessibilityOverride:
                        try container.encode("override")
                    case .accessibilityFileprivate:
                        try container.encode("fileprivate")
                    case .accessibilityOpen:
                        try container.encode("open")
                    case .accessibilityMutating:
                        try container.encode("mutating")
                    case .empty:
                        try container.encode("")
                    case .unsupported(let value):
                        try container.encode(value)
                }
            }
            
            init?(rawValue: String) {
                switch rawValue {
                    case "convenience":
                            self = .accessibilityConvenience
                    case "final":
                            self = .accessibilityFinal
                    case "internal":
                            self = .accessibilityInternal
                    case "lazy":
                            self = .accessibilityLazy
                    case "private":
                            self = .accessibilityPrivate
                    case "public":
                            self = .accessibilityPublic
                    case "required":
                            self = .accessibilityRequired
                    case "static":
                            self = .accessibilityStatic
                    case "weak":
                            self = .accessibilityWeak
                    case "override":
                            self = .accessibilityOverride
                    case "fileprivate":
                            self = .accessibilityFileprivate
                    case "open":
                            self = .accessibilityOpen
                    case "mutating":
                            self = .accessibilityMutating
                    case "":
                            self = .empty
                    default:
                        self = .unsupported(rawValue)
                        
                }
            }
            
            var rawValue: String {
                switch self {
                    case .accessibilityConvenience:
                        return "convenience"
                    case .accessibilityFinal:
                        return "final"
                    case .accessibilityInternal:
                        return "internal"
                    case .accessibilityLazy:
                        return "lazy"
                    case .accessibilityPrivate:
                        return "private"
                    case .accessibilityPublic:
                        return "public"
                    case .accessibilityRequired:
                        return "required"
                    case .accessibilityStatic:
                        return "static"
                    case .accessibilityWeak:
                        return "weak"
                    case .accessibilityOverride:
                        return "override"
                    case .accessibilityFileprivate:
                        return "fileprivate"
                    case .accessibilityOpen:
                        return "open"
                    case .accessibilityMutating:
                        return "mutating"
                    case .empty:
                        return ""
                    case .unsupported(let string):
                        return string
                }
            }
        }

        enum Hint: Codable, RawRepresentable, Equatable {
            case assignOnlyProperty
            case redundantConformance
            case redundantProtocol
            case redundantPublicAccessibility
            case unused
            case unsupported(String)
            
            private enum CodingKeys: CodingKey {}
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let decodedString = try container.decode(String.self)
                
                switch decodedString {
                    case "assignOnlyProperty":
                        self = .assignOnlyProperty
                    case "redundantConformance":
                        self = .redundantConformance
                    case "redundantProtocol":
                        self = .redundantProtocol
                    case "redundantPublicAccessibility":
                        self = .redundantPublicAccessibility
                    case "unused":
                        self = .unused
                    default:
                        self = .unsupported(decodedString)
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                
                switch self {
                    case .assignOnlyProperty:
                        try container.encode("assignOnlyProperty")
                    case .redundantConformance:
                        try container.encode("redundantConformance")
                    case .redundantProtocol:
                        try container.encode("redundantProtocol")
                    case .redundantPublicAccessibility:
                        try container.encode("redundantPublicAccessibility")
                    case .unused:
                        try container.encode("unused")
                    case .unsupported(let value):
                        try container.encode(value)
                }
            }
            
            init?(rawValue: String) {
                switch rawValue {
                    case "assignOnlyProperty":
                        self = .assignOnlyProperty
                    case "redundantConformance":
                        self = .redundantConformance
                    case "redundantProtocol":
                        self = .redundantProtocol
                    case "redundantPublicAccessibility":
                        self = .redundantPublicAccessibility
                    case "unused":
                        self = .unused
                    default:
                        self = .unsupported(rawValue)
                        
                }
            }
            
            var rawValue: String {
                switch self {
                    case .assignOnlyProperty:
                        return "assignOnlyProperty"
                    case .redundantConformance:
                        return "redundantConformance"
                    case .redundantProtocol:
                        return "redundantProtocol"
                    case .redundantPublicAccessibility:
                        return "redundantPublicAccessibility"
                    case .unused:
                        return "unused"
                    case .unsupported(let string):
                        return string
                }
            }
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
