import Foundation
import Parsing

public struct WebVTTParser {
    private let parser = ElementsParser()

    public init() {}

    public func parse(_ content: String) throws -> WebVTT {
        try parser.parse(content.trimmingEdges(while: \.isNewline))
    }

    public func print(_ srt: WebVTT) throws -> String {
        String(try parser.print(srt))
    }
}

struct ElementsParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT> {
        ParsePrint(.memberwise(WebVTT.init(header:elements:))) {
            HeaderParser()
            Many {
                OneOf {
                    NoteParser()
                        .map(.case(WebVTT.Element.note))
                    StyleParser()
                        .map(.case(WebVTT.Element.style))
                    RegionParser()
                        .map(.case(WebVTT.Element.region))
                    CueParser()
                        .map(.case(WebVTT.Element.cue))
                    TextParser(upTo: .newlines, count: 2)
                        .map(.case(WebVTT.Element.unknown))
                }
            } separator: {
                Whitespace(2..., .vertical)
            } terminator: {
                End()
            }
        }
    }
}

struct HeaderParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Header> {
        ParsePrint(.memberwise(WebVTT.Header.init(text:metadata:))) {
            "WEBVTT"
            Optionally {
                Whitespace(1..., .horizontal)
                TextParser(upTo: .newlines)
            }
            HeaderMetadataParser()
            Whitespace(2..., .vertical)
        }
    }
}

struct HeaderMetadataParser: ParserPrinter {
    func parse(_ input: inout Substring) throws -> [WebVTT.HeaderMetadata] {
        let substring = input.prefix(upTo: .newlines, count: 2)
        input.removeFirst(substring.count)

        let lines = substring
            .trimmingEdges(while: \.isNewline)
            .components(separatedBy: .newlines)
            .map { $0.trimmingEdges(while: \.isWhitespace) }
            .filter { !$0.isEmpty }

        return lines.compactMap { line -> WebVTT.HeaderMetadata? in
            let components = line
                .components(separatedBy: CharacterSet(charactersIn: ":"))
                .map { $0.trimmingEdges(while: \.isWhitespace) }
                .filter { !$0.isEmpty }
            guard components.count == 2 else { return nil }
            return WebVTT.HeaderMetadata(key: components[0], value: components[1])
        }
    }

    func print(_ output: [WebVTT.HeaderMetadata], into input: inout Substring) throws {
        for metadata in output.reversed() {
            input.prepend(contentsOf: "\(metadata.key): \(metadata.value)")
            input.prepend("\n")
        }
    }
}

struct NoteParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Note> {
        ParsePrint(.memberwise(WebVTT.Note.init(text:))) {
            "NOTE"
            OneOf {
                Whitespace(1..., .horizontal)
                Whitespace(1..., .vertical)
            }
            TextParser(upTo: .newlines, count: 2)
        }
    }
}

struct StyleParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Style> {
        ParsePrint(.memberwise(WebVTT.Style.init(text:))) {
            "STYLE"
            Whitespace(1..., .vertical)
            TextParser(upTo: .newlines, count: 2)
        }
    }
}

struct RegionParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Region> {
        ParsePrint(.memberwise(WebVTT.Region.init(settings:))) {
            OneOf {
                "REGION"
                "Region:"
            }.printing("REGION")
            OneOf {
                Whitespace(1..., .horizontal)
                Whitespace(1, .vertical)
            }
            Many {
                RegionSettingParser()
            } separator: {
                OneOf {
                    Whitespace(1..., .horizontal)
                    Whitespace(1, .vertical)
                }
            }
        }
    }
}

struct RegionSettingParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionSetting> {
        ParsePrint {
            OneOf {
                RegionIDParser()
                RegionLinesParser()
                RegionWidthParser()
                RegionScrollParser()
                RegionAnchorSettingParser()
                RegionViewPortAnchorSettingParser()
            }
        }
    }
}

struct RegionIDParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionSetting> {
        ParsePrint {
            "id"
            Whitespace(.horizontal)
            OneOf {
                ":"
                "="
            }.printing(":")
            Whitespace(.horizontal)
            TextParser(upTo: .whitespacesAndNewlines)
        }
        .map(.case(WebVTT.RegionSetting.id))
    }
}

struct RegionLinesParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionSetting> {
        ParsePrint {
            "lines"
            Whitespace(.horizontal)
            OneOf {
                ":"
                "="
            }.printing(":")
            Whitespace(.horizontal)
            Int.parser()
        }
        .map(.case(WebVTT.RegionSetting.lines))
    }
}

struct RegionWidthParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionSetting> {
        ParsePrint {
            "width"
            Whitespace(.horizontal)
            OneOf {
                ":"
                "="
            }.printing(":")
            Whitespace(.horizontal)
            Int.parser()
            "%"
        }
        .map(.case(WebVTT.RegionSetting.widthPercentage))
    }
}

struct RegionScrollParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionSetting> {
        ParsePrint {
            "scroll"
            Whitespace(.horizontal)
            OneOf {
                ":"
                "="
            }.printing(":")
            Whitespace(.horizontal)
            WebVTT.RegionScroll.parser()
        }
        .map(.case(WebVTT.RegionSetting.scroll))
    }
}

struct RegionAnchorSettingParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionSetting> {
        ParsePrint {
            "regionanchor"
            Whitespace(.horizontal)
            OneOf {
                ":"
                "="
            }.printing(":")
            Whitespace(.horizontal)
            RegionAnchorParser()
        }
        .map(.case(WebVTT.RegionSetting.anchor))
    }
}

struct RegionViewPortAnchorSettingParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionSetting> {
        ParsePrint {
            "viewportanchor"
            Whitespace(.horizontal)
            OneOf {
                ":"
                "="
            }.printing(":")
            Whitespace(.horizontal)
            RegionAnchorParser()
        }
        .map(.case(WebVTT.RegionSetting.viewPortAnchor))
    }
}

struct RegionAnchorParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.RegionAnchor> {
        ParsePrint(.memberwise(WebVTT.RegionAnchor.init(xPercentage:yPercentage:))) {
            Int.parser()
            Whitespace(.horizontal)
            "%"
            Whitespace(.horizontal)
            ","
            Whitespace(.horizontal)
            Int.parser()
            Whitespace(.horizontal)
            "%"
        }
    }
}

struct CueParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Cue> {
        ParsePrint(.memberwise(WebVTT.Cue.init(metadata:payload:))) {
            CueMetadataParser()
            CuePayloadParser()
        }
    }
}

struct CueMetadataParser: ParserPrinter {
    var body: some Parser<Substring, WebVTT.CueMetadata> {
        Optionally {
            TimingParser()
        }.flatMap { timing in
            if let timing {
                Parse { settings in
                    WebVTT.CueMetadata(
                        identifier: nil,
                        timing: timing,
                        settings: settings
                    )
                } with: {
                    SettingsParser()
                }
            } else {
                Parse { identifier, timing, settings in
                    WebVTT.CueMetadata(identifier: identifier, timing: timing, settings: settings)
                } with: {
                    TextParser(upTo: .newlines)
                        .map { String?.some($0) }
                    Whitespace(1, .vertical)
                    TimingParser()
                    SettingsParser()
                }
            }
        }
    }

    func print(_ output: WebVTT.CueMetadata, into input: inout Substring) throws {
        try SettingsParser().print(output.settings, into: &input)
        try TimingParser().print(output.timing, into: &input)
        if let identifier = output.identifier {
            input.prepend("\n")
            input.prepend(contentsOf: identifier)
        }
    }
}

struct TimingParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Timing> {
        ParsePrint(.memberwise(WebVTT.Timing.init(start:end:))) {
            TimeParser()
            "-->"
            TimeParser()
        }
    }

    func print(_ output: WebVTT.Timing, into input: inout Substring) throws {
        try TimeParser().print(output.end, into: &input)
        input.prepend(contentsOf: " --> ")
        try TimeParser().print(output.start, into: &input)
    }
}

struct TimeParser: ParserPrinter {
    private func isHorizontalWhitespace(_ char: Character) -> Bool {
        [
            Character(" "),
            Character("\t"),
            Character("\u{000B}"),
            Character("\u{000C}")
        ].contains(char)
    }

    private var whitespace: some ParserPrinter<Substring, Void> {
        Skip {
            Prefix(while: isHorizontalWhitespace)
        }.printing("")
    }

    var body: some ParserPrinter<Substring, WebVTT.Time> {
        ParsePrint(.memberwise(WebVTT.Time.init(first:second:third:milliseconds:))) {
            whitespace
            Int.parser()
            ":"
            Int.parser()
            Optionally {
                ":"
                Int.parser()
            }
            "."
            Int.parser()
            whitespace
        }
    }

    func print(_ output: WebVTT.Time, into input: inout Substring) throws {
        let components = [
            output.hours == 0 ? nil : String(format: "%02d", output.hours),
            String(format: "%02d", output.minutes),
            String(format: "%02d", output.seconds)
        ].compactMap { $0 }
        let allComponents = [
            components.joined(separator: ":"),
            String(format: "%03d", output.milliseconds)
        ]
        let text = allComponents.joined(separator: ".")
        input.prepend(contentsOf: text)
    }
}

struct TextParser: ParserPrinter {
    let terminator: CharacterSet
    let count: Int
    let includeTerminator: Bool

    init(upTo terminator: String, count: Int = 1, includeTerminator: Bool = false) {
        self.terminator = CharacterSet(charactersIn: terminator)
        self.count = count
        self.includeTerminator = includeTerminator
    }

    init(upTo terminator: CharacterSet, count: Int = 1, includeTerminator: Bool = false) {
        self.terminator = terminator
        self.count = count
        self.includeTerminator = includeTerminator
    }

    func parse(_ input: inout Substring) throws -> String {
        let prefix = input.prefix(
            upTo: terminator,
            count: count,
            includeTerminator: includeTerminator
        )
        let text = EntityCoder().decode(String(prefix))
        input.removeFirst(prefix.count)

        return text
    }

    func print(_ output: String, into input: inout Substring) throws {
        input.prepend(contentsOf: EntityCoder().encode(output))
    }
}

struct CuePayloadParser: ParserPrinter {
    func parse(_ input: inout Substring) throws -> WebVTT.CuePayload {
        let prefix = input.prefix(upTo: .newlines, count: 2)
        let text = try CuePayloadBuilder().parse(String(prefix))
        input.removeFirst(prefix.count)

        return text
    }

    func print(_ output: WebVTT.CuePayload, into input: inout Substring) throws {
        input.prepend(contentsOf: try CuePayloadBuilder().print(output))
    }
}

struct SettingsParser: ParserPrinter {
    var body: some ParserPrinter<Substring, [WebVTT.Setting]> {
        ParsePrint {
            Many {
                SettingParser()
            } separator: {
                OneOf {
                    Whitespace(1..., .horizontal)
                    ",".utf8
                }
            } terminator: {
                Whitespace(1, .vertical)
            }
        }
    }

    func print(_ output: [WebVTT.Setting], into input: inout Substring) throws {
        input.prepend("\n")
        try output.reversed().forEach { setting in
            try SettingParser().print(setting, into: &input)
            input.prepend(" ")
        }
    }
}

struct SettingParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            OneOf {
                DirectionParser()
                AlignmentParser()
                PositionParser()
                SizeParser()
                LinePercentageParser()
                LineNumberParser()
                RegionIdentifierParser()
            }
        }
    }
}

struct DirectionParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            "vertical"
            Whitespace(.horizontal)
            ":"
            Whitespace(.horizontal)
            WebVTT.Setting.Direction.parser()
        }
        .map(.case(WebVTT.Setting.vertical))
    }
}

struct LineNumberParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            "line"
            Whitespace(.horizontal)
            ":"
            Whitespace(.horizontal)
            Int.parser()
        }
        .map(.case(WebVTT.Setting.lineNumber))
    }
}

struct LinePercentageParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            "line"
            Whitespace(.horizontal)
            ":"
            Whitespace(.horizontal)
            Int.parser()
            "%"
        }
        .map(.case(WebVTT.Setting.linePercentage))
    }
}

struct PositionParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            "position"
            Whitespace(.horizontal)
            ":"
            Whitespace(.horizontal)
            Int.parser()
            "%"
        }
        .map(.case(WebVTT.Setting.position))
    }
}

struct SizeParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            "size"
            Whitespace(.horizontal)
            ":"
            Whitespace(.horizontal)
            Int.parser()
            "%"
        }
        .map(.case(WebVTT.Setting.size))
    }
}

struct AlignmentParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            "align"
            Whitespace(.horizontal)
            ":"
            Whitespace(.horizontal)
            WebVTT.Setting.Alignment.parser()
        }
        .map(.case(WebVTT.Setting.align))
    }
}

struct RegionIdentifierParser: ParserPrinter {
    var body: some ParserPrinter<Substring, WebVTT.Setting> {
        ParsePrint {
            "region"
            Whitespace(.horizontal)
            ":"
            Whitespace(.horizontal)
            TextParser(upTo: .whitespacesAndNewlines)
        }
        .map(.case(WebVTT.Setting.region))
    }
}

// swiftlint:disable:this file_length
