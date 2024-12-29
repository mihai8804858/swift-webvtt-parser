import Foundation

public struct WebVTT: Hashable, Sendable {
    public let header: Header
    public let elements: [Element]

    public init(elements: [Element]) {
        self.header = Header(text: nil)
        self.elements = elements
    }

    public init(@ArrayBuilder<Element> elements: () -> [Element]) {
        self.header = Header(text: nil)
        self.elements = elements()
    }

    public init(header: Header, elements: [Element]) {
        self.header = header
        self.elements = elements
    }

    public init(header: Header, @ArrayBuilder<Element> elements: () -> [Element]) {
        self.header = header
        self.elements = elements()
    }
}

extension WebVTT {
    public struct Header: Hashable, Sendable {
        public let text: String?
        public let metadata: [HeaderMetadata]

        public init(text: String? = nil, metadata: [HeaderMetadata] = []) {
            self.text = text
            self.metadata = metadata
        }
    }
}

extension WebVTT {
    public struct HeaderMetadata: Hashable, Sendable {
        public let key: String
        public let value: String

        public init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }
}

extension WebVTT {
    public enum Element: Hashable, Sendable {
        case note(Note)
        case style(Style)
        case region(Region)
        case cue(Cue)
        case unknown(String)
    }
}

extension WebVTT {
    public struct Note: Hashable, Sendable {
        public let text: String

        public init(text: String) {
            self.text = text
        }
    }
}

extension WebVTT {
    public struct Style: Hashable, Sendable {
        public let text: String

        public init(text: String) {
            self.text = text
        }
    }
}

extension WebVTT {
    public struct Region: Hashable, Sendable {
        public let settings: [RegionSetting]

        public init(settings: [RegionSetting]) {
            self.settings = settings.uniqued()
        }

        public init(@ArrayBuilder<RegionSetting> settings: () -> [RegionSetting]) {
            self.settings = settings().uniqued()
        }
    }
}

extension WebVTT {
    public enum RegionSetting: Hashable, Sendable {
        case id(String)
        case lines(Int)
        case widthPercentage(Int)
        case scroll(RegionScroll)
        case anchor(RegionAnchor)
        case viewPortAnchor(RegionAnchor)
    }
}

extension WebVTT {
    public struct RegionAnchor: Hashable, Sendable {
        public let xPercentage: Int
        public let yPercentage: Int

        public init(xPercentage: Int, yPercentage: Int) {
            self.xPercentage = xPercentage
            self.yPercentage = yPercentage
        }
    }
}

extension WebVTT {
    public enum RegionScroll: String, Hashable, CaseIterable, Sendable {
        case up // swiftlint:disable:this identifier_name
        case down
        case left
        case right
    }
}

extension WebVTT {
    public struct Cue: Hashable, Sendable {
        public let metadata: CueMetadata
        public let payload: CuePayload

        public init(metadata: CueMetadata, payload: CuePayload) {
            self.metadata = metadata
            self.payload = payload
        }

        public init(
            metadata: CueMetadata,
            @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
        ) {
            self.metadata = metadata
            self.payload = CuePayload(components: components)
        }
    }
}

extension WebVTT {
    public struct CueMetadata: Hashable, Sendable {
        public let identifier: String?
        public let timing: Timing
        public let settings: [Setting]

        public init(identifier: String? = nil, timing: Timing, settings: [Setting] = []) {
            self.identifier = identifier
            self.timing = timing
            self.settings = settings.uniqued()
        }

        public init(identifier: String? = nil, timing: ClosedRange<TimeInterval>, settings: [Setting] = []) {
            self.identifier = identifier
            self.timing = Timing(timing)
            self.settings = settings.uniqued()
        }
    }
}

extension WebVTT {
    public struct Timing: Hashable, Sendable {
        public let start: Time
        public let end: Time

        public init(_ range: ClosedRange<TimeInterval>) {
            self.start = Time(interval: range.lowerBound)
            self.end = Time(interval: range.upperBound)
        }

        public init(start: Time, end: Time) {
            self.start = start
            self.end = end
        }
    }
}

extension WebVTT {
    public struct Time: Hashable, Sendable {
        public let hours: Int
        public let minutes: Int
        public let seconds: Int
        public let milliseconds: Int

        public var interval: TimeInterval {
            let seconds = TimeInterval(seconds)
            let minutes = TimeInterval(minutes * 60)
            let hours = TimeInterval(hours * 60 * 60)
            let milliseconds = TimeInterval(milliseconds) / 1000

            return hours + minutes + seconds + milliseconds
        }

        public init(hours: Int, minutes: Int, seconds: Int, milliseconds: Int) {
            self.hours = hours
            self.minutes = minutes
            self.seconds = seconds
            self.milliseconds = milliseconds
        }

        public init(interval: TimeInterval) {
            let milliseconds = Int(interval * 1000)

            let millisecondsPerSecond = 1000
            let millisecondsPerMinute = 60 * millisecondsPerSecond
            let millisecondsPerHour = 60 * millisecondsPerMinute

            let completeHours = milliseconds / millisecondsPerHour
            let remainingAfterHours = milliseconds % millisecondsPerHour

            let completeMinutes = remainingAfterHours / millisecondsPerMinute
            let remainingAfterMinutes = remainingAfterHours % millisecondsPerMinute

            let completeSeconds = remainingAfterMinutes / millisecondsPerSecond
            let remainingAfterSeconds = remainingAfterMinutes % millisecondsPerSecond

            self.init(
                hours: completeHours,
                minutes: completeMinutes,
                seconds: completeSeconds,
                milliseconds: remainingAfterSeconds
            )
        }

        init(first: Int, second: Int, third: Int?, milliseconds: Int) {
            if let third {
                self.init(hours: first, minutes: second, seconds: third, milliseconds: milliseconds)
            } else {
                self.init(hours: 0, minutes: first, seconds: second, milliseconds: milliseconds)
            }
        }
    }
}

extension WebVTT {
    public enum Setting: Hashable, Sendable {
        case vertical(Direction)
        case lineNumber(Int)
        case linePercentage(Int)
        case position(Int)
        case size(Int)
        case align(Alignment)
        case region(String)

        public enum Direction: String, Hashable, CaseIterable, Sendable {
            case lr // swiftlint:disable:this identifier_name
            case rl // swiftlint:disable:this identifier_name
        }

        public enum Alignment: String, Hashable, CaseIterable, Sendable {
            case start
            case left
            case center
            case middle
            case end
            case right
        }
    }
}

extension WebVTT {
    public struct CuePayload: Hashable, Sendable {
        public enum Component: Hashable, Sendable {
            case plain(text: String)
            case bold(classes: [String] = [], children: [Component])
            case italic(classes: [String] = [], children: [Component])
            case underline(classes: [String] = [], children: [Component])
            case ruby(classes: [String] = [], children: [Component])
            case rubyText(classes: [String] = [], children: [Component])
            case `class`(name: String? = nil, children: [Component])
            case voice(classes: [String] = [], name: String, children: [Component])
            case timestamp(time: Time, children: [Component])
            case language(classes: [String] = [], locale: String, children: [Component])
        }

        public let components: [Component]

        public init(components: [Component]) {
            self.components = components
        }

        public init(@ArrayBuilder<Component> components: () -> [Component]) {
            self.components = components()
        }

        public init(text: String) throws {
            self = try CuePayloadBuilder().parse(text)
        }
    }
}

public func plain(_ text: String) -> WebVTT.CuePayload.Component {
    .plain(text: text)
}

public func bold(
    classes: [String] = [],
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .bold(classes: classes, children: components())
}

public func italic(
    classes: [String] = [],
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .italic(classes: classes, children: components())
}

public func underline(
    classes: [String] = [],
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .underline(classes: classes, children: components())
}

public func ruby(
    classes: [String] = [],
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .ruby(classes: classes, children: components())
}

public func rubyText(
    classes: [String] = [],
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .rubyText(classes: classes, children: components())
}

public func styleClass(
    name: String? = nil,
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .class(name: name, children: components())
}

public func voice(
    classes: [String] = [],
    name: String,
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .voice(classes: classes, name: name, children: components())
}

public func timestamp(
    time: WebVTT.Time,
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .timestamp(time: time, children: components())
}

public func timestamp(
    interval: TimeInterval,
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .timestamp(time: WebVTT.Time(interval: interval), children: components())
}

public func language(
    classes: [String] = [],
    locale: String,
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.CuePayload.Component {
    .language(classes: classes, locale: locale, children: components())
}

public func unknown(_ text: String) -> WebVTT.Element {
    .unknown(text)
}

public func note(_ note: WebVTT.Note) -> WebVTT.Element {
    .note(note)
}

public func note(_ text: String) -> WebVTT.Element {
    .note(WebVTT.Note(text: text))
}

public func style(_ style: WebVTT.Style) -> WebVTT.Element {
    .style(style)
}

public func style(_ text: String) -> WebVTT.Element {
    .style(WebVTT.Style(text: text))
}

public func region(_ region: WebVTT.Region) -> WebVTT.Element {
    .region(region)
}

public func region(
    @ArrayBuilder<WebVTT.RegionSetting> _ settings: () -> [WebVTT.RegionSetting]
) -> WebVTT.Element {
    .region(WebVTT.Region(settings: settings))
}

public func cue(_ cue: WebVTT.Cue) -> WebVTT.Element {
    .cue(cue)
}

public func cue(
    _ metadata: WebVTT.CueMetadata,
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.Element {
    .cue(WebVTT.Cue(metadata: metadata, components: components))
}

public func cue(
    identifier: String? = nil,
    timing: WebVTT.Timing,
    settings: [WebVTT.Setting] = [],
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.Element {
    .cue(WebVTT.Cue(metadata: WebVTT.CueMetadata(
        identifier: identifier,
        timing: timing,
        settings: settings
    ), components: components))
}

public func cue(
    identifier: String? = nil,
    timing: ClosedRange<TimeInterval>,
    settings: [WebVTT.Setting] = [],
    @ArrayBuilder<WebVTT.CuePayload.Component> components: () -> [WebVTT.CuePayload.Component]
) -> WebVTT.Element {
    .cue(WebVTT.Cue(metadata: WebVTT.CueMetadata(
        identifier: identifier,
        timing: timing,
        settings: settings
    ), components: components))
}

// swiftlint:disable:this file_length
