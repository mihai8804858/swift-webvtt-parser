import RegexBuilder

struct CuePayloadBuilder {
    private let builders: [CuePayloadComponentBuilder] = [
        BoldComponentBuilder(),
        ItalicComponentBuilder(),
        UnderlineComponentBuilder(),
        RubyComponentBuilder(),
        RubyTextComponentBuilder(),
        ClassComponentBuilder(),
        VoiceComponentBuilder(),
        TimestampComponentBuilder(),
        LanguageComponentBuilder(),
        CueStyleComponentBuilder()
    ]

    func parse(_ text: String) throws -> WebVTT.CuePayload {
        WebVTT.CuePayload(components: try parse(text))
    }

    func print(_ payload: WebVTT.CuePayload) throws -> String {
        try print(payload.components)
    }

    private func parse(_ text: String) throws -> [WebVTT.CuePayload.Component] {
        let components = try builders.map { try $0.build(text) }.sorted { lhs, rhs in
            guard let rhs else { return true }
            guard let lhs else { return false }
            return lhs.0.lowerBound < rhs.0.lowerBound
        }
        guard let component = components.first, let component else {
            return [.plain(text: EntityCoder().decode(text))]
        }
        let (leading, trailing) = try parseEdges(from: text, relativeTo: component)

        return leading + [component.1] + trailing
    }

    private func print(_ component: WebVTT.CuePayload.Component) throws -> String {
        switch component {
        case .plain(let text):
            return EntityCoder().encode(text)
        case .bold(let classes, let components):
            let classes = classes.map { ".\($0)" }.joined()
            let children = try components.map(print).joined()
            return "<b\(classes)>\(children)</b>"
        case .italic(let classes, let components):
            let classes = classes.map { ".\($0)" }.joined()
            let children = try components.map(print).joined()
            return "<i\(classes)>\(children)</i>"
        case .underline(let classes, let components):
            let classes = classes.map { ".\($0)" }.joined()
            let children = try components.map(print).joined()
            return "<u\(classes)>\(children)</u>"
        case .ruby(let classes, let components):
            let classes = classes.map { ".\($0)" }.joined()
            let children = try components.map(print).joined()
            return "<ruby\(classes)>\(children)</ruby>"
        case .rubyText(let classes, let components):
            let classes = classes.map { ".\($0)" }.joined()
            let children = try components.map(print).joined()
            return "<rt\(classes)>\(children)</rt>"
        case .class(let name, let components):
            let children = try components.map(print).joined()
            let nameComponent = name.map { ".\($0)" } ?? ""
            return "<c\(nameComponent)>\(children)</c>"
        case .voice(let classes, let name, let components):
            let classes = classes.map { ".\($0)" }.joined()
            let children = try components.map(print).joined()
            return "<v\(classes) \(name)>\(children)</v>"
        case .timestamp(let time, let components):
            let time = try TimeParser().print(time)
            let children = try components.map(print).joined()
            return "<\(time)>\(children)"
        case .language(let classes, let locale, let components):
            let classes = classes.map { ".\($0)" }.joined()
            let children = try components.map(print).joined()
            return "<lang\(classes) \(locale)>\(children)</lang>"
        }
    }

    private func parseEdges(
        from text: String,
        relativeTo component: (Range<String.Index>, WebVTT.CuePayload.Component)
    ) throws -> (leading: [WebVTT.CuePayload.Component], trailing: [WebVTT.CuePayload.Component]) {
        let leadingText: String? = if component.0.lowerBound > text.startIndex {
            String(text[..<component.0.lowerBound])
        } else {
            nil
        }
        let trailingText: String? = if component.0.upperBound < text.endIndex {
            String(text[component.0.upperBound...])
        } else {
            nil
        }
        let leading = try leadingText.map { try parse($0) } ?? []
        let trailing = try trailingText.map { try parse($0) } ?? []

        return (leading, trailing)
    }

    private func print(_ components: [WebVTT.CuePayload.Component]) throws -> String {
        try components.map(print).joined()
    }
}

private protocol CuePayloadComponentBuilder {
    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)?
}

private struct BoldComponentBuilder: CuePayloadComponentBuilder {
    private let classesReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring)> {
        Regex {
            "<b"
            Optionally {
                "."
                Capture(as: classesReference) {
                    ZeroOrMore(.any)
                }
            }
            Optionally {
                " "
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</b>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let classes = match.output.1.map(String.init).map { $0.components(separatedBy: ".") } ?? []
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.bold(classes: classes, children: children.components)

        return (match.range, component)
    }
}

private struct ItalicComponentBuilder: CuePayloadComponentBuilder {
    private let classesReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring)> {
        Regex {
            "<i"
            Optionally {
                "."
                Capture(as: classesReference) {
                    ZeroOrMore(.any)
                }
            }
            Optionally {
                " "
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</i>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let classes = match.output.1.map(String.init).map { $0.components(separatedBy: ".") } ?? []
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.italic(classes: classes, children: children.components)

        return (match.range, component)
    }
}

private struct UnderlineComponentBuilder: CuePayloadComponentBuilder {
    private let classesReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring)> {
        Regex {
            "<u"
            Optionally {
                "."
                Capture(as: classesReference) {
                    ZeroOrMore(.any)
                }
            }
            Optionally {
                " "
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</u>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let classes = match.output.1.map(String.init).map { $0.components(separatedBy: ".") } ?? []
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.underline(classes: classes, children: children.components)

        return (match.range, component)
    }
}

private struct RubyComponentBuilder: CuePayloadComponentBuilder {
    private let classesReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring)> {
        Regex {
            "<ruby"
            Optionally {
                "."
                Capture(as: classesReference) {
                    ZeroOrMore(.any)
                }
            }
            Optionally {
                " "
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</ruby>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let classes = match.output.1.map(String.init).map { $0.components(separatedBy: ".") } ?? []
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.ruby(classes: classes, children: children.components)

        return (match.range, component)
    }
}

private struct RubyTextComponentBuilder: CuePayloadComponentBuilder {
    private let classesReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring)> {
        Regex {
            "<rt"
            Optionally {
                "."
                Capture(as: classesReference) {
                    ZeroOrMore(.any)
                }
            }
            Optionally {
                " "
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</rt>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let classes = match.output.1.map(String.init).map { $0.components(separatedBy: ".") } ?? []
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.rubyText(classes: classes, children: children.components)

        return (match.range, component)
    }
}

private struct ClassComponentBuilder: CuePayloadComponentBuilder {
    private let nameReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring)> {
        Regex {
            "<c"
            Optionally {
                "."
                Capture(as: nameReference) {
                    ZeroOrMore(.any)
                }
            }
            Optionally {
                " "
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</c>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let name = match.output.1.map(String.init)
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.class(name: name, children: children.components)

        return (match.range, component)
    }
}

private struct VoiceComponentBuilder: CuePayloadComponentBuilder {
    private let classesReference = Reference(Substring.self)
    private let nameReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring, Substring)> {
        Regex {
            "<v"
            Optionally {
                "."
                Capture(as: classesReference) {
                    ZeroOrMore(.any)
                }
            }
            " "
            Capture(as: nameReference) {
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            ChoiceOf {
                "</v>"
                Anchor.endOfSubject
            }
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let classes = match.output.1.map(String.init).map { $0.components(separatedBy: ".") } ?? []
        let name = String(match[nameReference])
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.voice(classes: classes, name: name, children: children.components)

        return (match.range, component)
    }
}

private struct TimestampComponentBuilder: CuePayloadComponentBuilder {
    private let timeReference = Reference(WebVTT.Time.self)
    private let textReference = Reference(Substring.self)

    private var timeRegex: Regex<Substring> {
        Regex {
            "<"
            OneOrMore(.digit)
            ":"
            OneOrMore(.digit)
            Optionally {
                ":"
                OneOrMore(.digit)
            }
            "."
            OneOrMore(.digit)
            ">"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    private var regex: Regex<(Substring, WebVTT.Time, Substring)> {
        Regex {
            Capture(as: timeReference) {
                timeRegex
            } transform: { input in
                try TimeParser().parse(String(input).dropFirst().dropLast())
            }
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            ChoiceOf {
                Lookahead {
                    timeRegex
                }
                Anchor.endOfSubject
            }
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let time = match[timeReference]
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.timestamp(time: time, children: children.components)

        return (match.range, component)
    }
}

private struct LanguageComponentBuilder: CuePayloadComponentBuilder {
    private let classesReference = Reference(Substring.self)
    private let localeReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring?, Substring, Substring)> {
        Regex {
            "<lang"
            Optionally {
                "."
                Capture(as: classesReference) {
                    ZeroOrMore(.any)
                }
            }
            " "
            Capture(as: localeReference) {
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</lang>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let classes = match.output.1.map(String.init).map { $0.components(separatedBy: ".") } ?? []
        let locale = String(match[localeReference])
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.language(
            classes: classes,
            locale: locale,
            children: children.components
        )

        return (match.range, component)
    }
}

private struct CueStyleComponentBuilder: CuePayloadComponentBuilder {
    private let nameReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring, Substring)> {
        Regex {
            "<"
            Capture(as: nameReference) {
                ZeroOrMore(.any)
            }
            ">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</"
            nameReference
            ">"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func build(_ text: String) throws -> (range: Range<String.Index>, component: WebVTT.CuePayload.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let children = try CuePayloadBuilder().parse(String(match[textReference]))
        let component = WebVTT.CuePayload.Component.class(
            name: String(match[nameReference]),
            children: children.components
        )

        return (match.range, component)
    }
}

// swiftlint:disable:this file_length
