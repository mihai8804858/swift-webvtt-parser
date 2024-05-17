import Foundation

struct EntityCoder {
    private static let requiredDecodeMapping: [(String, String)] = [
        ("&amp;", "&"),
        ("&nbsp;", "\u{00a0}"),
        ("&lrm;", "\u{200e}"),
        ("&rlm;", "\u{200f}"),
        ("&lt;", "<"),
        ("&gt;", ">")
    ]

    private static let requiredEncodeMapping: [(String, String)] = [
        ("&", "&amp;"),
        ("\u{00a0}", "&nbsp;"),
        ("\u{200e}", "&lrm;"),
        ("\u{200f}", "&rlm;"),
        ("<", "&lt;"),
        (">", "&gt;")
    ]

    private static let fullDecodeMapping: [String: String] = {
        guard let mappingURL = Bundle.module.url(forResource: "entities", withExtension: "json"),
              let data = try? Data(contentsOf: mappingURL),
              let mapping = try? JSONDecoder().decode([String: String].self, from: data) else {
            return Dictionary(uniqueKeysWithValues: requiredDecodeMapping)
        }

        return mapping
    }()

    func decode(_ content: String) -> String {
        func decodeNumeric(_ string: Substring, base: Int) -> String? {
            guard let code = UInt32(string, radix: base), let scalar = UnicodeScalar(code) else { return nil }
            return String(Character(scalar))
        }

        func decode(_ entity: Substring) -> String? {
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return EntityCoder.fullDecodeMapping[String(entity)]
            }
        }

        var result = ""
        var position = content.startIndex

        while let ampRange = content[position...].range(of: "&") {
            result.append(contentsOf: content[position..<ampRange.lowerBound])
            position = ampRange.lowerBound
            guard let semiRange = content[position...].range(of: ";") else { break }
            let entity = content[position..<semiRange.upperBound]
            position = semiRange.upperBound
            if let decoded = decode(entity) {
                result.append(decoded)
            } else {
                result.append(contentsOf: entity)
            }
        }
        result.append(contentsOf: content[position...])

        return result
    }

    func encode(_ content: String) -> String {
        var result = content
        for (unescaped, escaped) in EntityCoder.requiredEncodeMapping {
            result = result.replacingOccurrences(
                of: unescaped,
                with: escaped,
                options: [.literal, .caseInsensitive]
            )
        }

        return result
    }
}
